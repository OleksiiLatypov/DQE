--1. Retrieve a list of all roles in the company, which should include the number of employees for each of role assigned

SELECT employee_role,
	COUNT(employee_id) AS number_of_employees
FROM 
	EmployeeRoles
GROUP BY 
	employee_role
ORDER BY 
	number_of_employees DESC;



-- 2. Get roles which has no employees assigned

SELECT DISTINCT employee_role 
FROM 
	EmployeeRoles
WHERE 
	employee_id IS NULL;


-- 3. Get projects list where every project has list of roles supplied with number of employees


SELECT p.project_name,
	er.employee_role,
	COUNT(employee_id) AS number_of_employee
FROM 
	Projects p
LEFT JOIN
	EmployeeRoles er
ON
	p.project_id = er.project_id
GROUP BY p.project_name, er.employee_role
ORDER BY p.project_name, er.employee_role;




--4. For every project count how many tasks there are assigned for every employee in average

SELECT 
    project_id,
    AVG(task_count * 1.0) AS avg_tasks_per_employee
FROM 
    (SELECT project_id, assigned_to, COUNT(task_id) AS task_count
FROM dbo.Tasks
GROUP BY project_id, assigned_to) AS sub_query

GROUP BY 
    project_id;

	
         
         
-- 5. Determine duration for each project       
SELECT 
    p.project_id,
    p.project_name,
    DATEDIFF(
        DAY, 
        p.creation_date, 
        ISNULL(p.close_date, GETDATE())  -- Use current date if close_date is NULL
    ) AS project_duration_days
FROM 
    Projects p;
   
   
--Alternative 
SELECT 
    p.project_id,
    p.project_name,
    DATEDIFF(
        DAY, 
        p.creation_date, 
        CASE 
            WHEN p.close_date IS NULL THEN GETDATE() 
            ELSE p.close_date 
        END
    ) AS project_duration_days
FROM 
    Projects p;

   
   
   
   
-- 6. Identify which employees has the lowest number tasks with non-closed statuses.
   
-- Create a view that retrieves tasks with a status other than 'accepted' from TaskStatusHistory
CREATE VIEW TaskWithActiveStatus AS
SELECT 
    t.task_id,
    t.task_name,
    t.assigned_to,
    t.deadline,
    t.status
FROM 
    Tasks t
JOIN 
    TaskStatusHistory tsh ON t.task_id = tsh.task_id
WHERE 
    tsh.status != 'accepted';  -- Exclude accepted(closed) statuses
    
-- Select and summarize employee with the lowest task count
SELECT   
    CONCAT (e.first_name, ' ', e.last_name) AS fullname,
    COUNT(twas.task_id) AS number_of_tasks FROM TaskWithActiveStatus twas LEFT JOIN Employees e ON twas.assigned_to = e.employee_id
GROUP BY 
    e.employee_id, e.first_name, e.last_name
ORDER BY number_of_tasks;

    
    

--7. Identify which employees has the most tasks with non-closed statuses with failed deadlines.
-- Create a view that retrieves tasks with deadlines that have passed
CREATE VIEW ExpiredDeadline AS
SELECT 
    task_id, 
    task_name, 
    project_id, 
    assigned_to, 
    deadline, 
    status
FROM 
    Tasks
WHERE 
    deadline < GETDATE() 
    AND status NOT IN ('accepted');


-- Select and summarize task information, grouping by employee and deadline
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS fullname, 
    e.job_title, 
    ed.deadline, 
    COUNT(ed.task_id) AS number_of_tasks
FROM 
    ExpiredDeadline ed
LEFT JOIN 
    Employees e 
ON 
    ed.assigned_to = e.employee_id
GROUP BY 
    e.first_name, 
    e.last_name, 
    e.job_title, 
    ed.deadline;

   
-- 8. Move forward deadline for non-closed tasks in 5 days.

-- Create a function that moves the deadline by a specified number of days
CREATE FUNCTION MoveDeadline (
    @current_deadline DATE,   
    @days_to_add INT          
)
RETURNS DATE  
AS
BEGIN 
    -- Add the specified number of days to the current deadline and return the result
    RETURN DATEADD(DAY, @days_to_add, @current_deadline)
END;

-- Update the deadline for tasks that are not marked as 'done' or 'accepted'
UPDATE Tasks
SET 
    deadline = dbo.MoveDeadline(deadline, 5)  -- Use the MoveDeadline function to add 5 days to the current deadline
WHERE 
    status NOT IN ('done', 'accepted');  -- Apply the update only to tasks whose status is not 'done' or 'accepted'


	
-- 9. For each project count how many there are tasks which were not started yet.
--assume that a task is "not started yet" if its status is 'open'
SELECT 
    p.project_name, 
    COUNT(t.task_id) AS not_started_tasks
FROM 
    Projects p
LEFT JOIN 
    Tasks t ON p.project_id = t.project_id
WHERE 
    t.status = 'open'
GROUP BY 
    p.project_name;
   
   
-- 10. For each project which has all tasks marked as closed move status to closed.
-- Close date for such project should match close date for the last accepted task.
   

-- Create a view that combines tasks and their respective project details
CREATE VIEW TaskProjectView AS
SELECT 
    t.task_id,           
    t.task_name,         
    t.project_id,       
    t.status,            
    p.project_name,      
    p.state              
FROM 
    Tasks t
LEFT JOIN 
    Projects p 
    ON t.project_id = p.project_id; 
   
   
-- CTE (Common Table Expression) to identify projects where all tasks are accepted and project state is not 'closed'
WITH AcceptedProjects AS (
    SELECT DISTINCT 
        project_id  -- Select distinct project IDs
    FROM 
        TaskProjectView tpv  -- Use the previously created view for the tasks and project details
    WHERE 
        'accepted' = ALL (   -- Ensure all tasks in the project have 'accepted' status
            SELECT 
                status 
            FROM 
                Tasks sub_t 
            WHERE 
                sub_t.project_id = tpv.project_id
        )
        AND tpv.state != 'closed'  -- Filter out projects that are already closed
)

-- Update the close_date of projects that meet the criteria in the AcceptedProjects CTE
UPDATE Projects
SET close_date = (
    SELECT MAX(tsh.change_date)  -- Get the latest change_date when the task was marked as 'accepted'
    FROM TaskStatusHistory tsh
    WHERE 
        tsh.status = 'accepted' 
        AND tsh.task_id IN (    
            SELECT t.task_id
            FROM Tasks t
            WHERE t.project_id = Projects.project_id
        )
)
WHERE project_id IN (
    SELECT project_id  -- Only update projects found in the AcceptedProjects CTE
    FROM AcceptedProjects 
);  




-- 11. Determine employees across all projects which has not non-closed tasks assigned.


SELECT 
    e.employee_id, 
    CONCAT(e.first_name, ' ', e.last_name) AS fullname, 
    e.job_title
FROM 
    Employees e
WHERE 
    e.employee_id NOT IN (
        SELECT DISTINCT 
            t.assigned_to
        FROM 
            Tasks t
        JOIN 
            TaskStatusHistory tsh 
            ON t.task_id = tsh.task_id
        WHERE 
            tsh.status != 'accepted'
);


-- 12. Assign given project task (using task name as identifier) to an employee which has minimum tasks with open status.


-- Select the employee with the fewest open tasks
SELECT TOP 1 
    assigned_to
FROM 
    dbo.Tasks
WHERE 
    status = 'open'
GROUP BY 
    assigned_to
ORDER BY 
    COUNT(task_id) ASC;

-- Update the assigned_to field for a specific task
UPDATE Tasks
SET 
    assigned_to = (
        SELECT TOP 1 
            assigned_to
        FROM 
            dbo.Tasks
        WHERE 
            status = 'open'
        GROUP BY 
            assigned_to
        ORDER BY 
            COUNT(task_id) ASC
    )
WHERE 
    task_name = 'Initial Setup';




   
   
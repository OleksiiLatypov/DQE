-- 1. Retrieve a list of all roles in the company, which should include the number of employees for each of role assigned

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
GROUP BY employee_role
HAVING COUNT(employee_id) = 0;


--ALTERNATIVE APPROACH
SELECT employee_role
FROM EmployeeRoles
GROUP BY employee_role
HAVING SUM(CASE WHEN employee_id IS NOT NULL THEN 1 ELSE 0 END) = 0;




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




-- 4. For every project count how many tasks there are assigned for every employee in average

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
    tsh.status
FROM 
    Tasks t
JOIN 
    TaskStatusHistory tsh ON t.task_id = tsh.task_id
WHERE 
    tsh.status != 'accepted';  -- Exclude tasks with 'accepted' (closed) status
    
    
-- Select and summarize employee with the lowest task count
SELECT   
    CONCAT (e.first_name, ' ', e.last_name) AS fullname,
    COUNT(twas.task_id) AS number_of_tasks
FROM 
	TaskWithActiveStatus twas
LEFT JOIN 
	Employees e ON twas.assigned_to = e.employee_id
GROUP BY 
    e.employee_id, e.first_name, e.last_name
ORDER BY number_of_tasks;





-- 7. Identify which employees has the most tasks with non-closed statuses with failed deadlines.

-- Create a view that retrieves tasks with deadlines that have passed
CREATE VIEW ExpiredDeadline AS
SELECT 
    t.task_id, 
    t.task_name, 
    t.project_id, 
    t.assigned_to, 
    t.deadline, 
    tsh.status
FROM 
    Tasks t
JOIN 
    TaskStatusHistory tsh ON t.task_id = tsh.task_id
WHERE 
    t.deadline < GETDATE() -- Deadline has passed
    AND tsh.status != 'accepted'; -- Task is not in an 'accepted' (closed) status

SELECT * FROM ExpiredDeadline;

SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS fullname, 
    e.job_title, 
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
    e.job_title
ORDER BY 
    number_of_tasks DESC; -- Order by the most tasks with failed deadlines


    
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
FROM 
    Tasks t
JOIN 
    TaskStatusHistory tsh ON t.task_id = tsh.task_id
WHERE 
    tsh.status NOT IN ('done', 'accepted'); -- Update only tasks that are not 'done' or 'accepted'



-- 9. For each project count how many there are tasks which were not started yet.
--assume that a task is "not started yet" if its status is 'open'
   
SELECT 
    p.project_name, 
    COUNT(t.task_id) AS not_started_tasks
FROM 
    Projects p
INNER JOIN 
    Tasks t ON p.project_id = t.project_id
INNER JOIN 
    TaskStatusHistory tsh ON t.task_id = tsh.task_id
WHERE 
    tsh.status = 'open' -- Only include tasks with 'open' status
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
    p.project_name,      
    p.state              
FROM 
    Tasks t
LEFT JOIN 
    Projects p 
    ON t.project_id = p.project_id;


-- CTE (Common Table Expression) to identify projects where all tasks are accepted and project state is not 'closed'
WITH AcceptedProjects AS (
    SELECT 
        tpv.project_id  -- Select project IDs
    FROM 
        TaskProjectView tpv
    WHERE 
        'accepted' = ALL (  -- Ensure all tasks in the project have 'accepted' as the most recent status
            SELECT 
                tsh.status
            FROM 
                TaskStatusHistory tsh
            WHERE 
                tsh.task_id IN (
                    SELECT t.task_id 
                    FROM Tasks t 
                    WHERE t.project_id = tpv.project_id
                )
                AND tsh.change_date = (  -- Check the most recent status
                    SELECT MAX(sub_tsh.change_date) 
                    FROM TaskStatusHistory sub_tsh 
                    WHERE sub_tsh.task_id = tsh.task_id
                )
        )
        AND tpv.state != 'closed'  -- Exclude projects already closed
)
-- Update projects identified by the CTE
UPDATE Projects
SET 
    state = 'closed',
    close_date = (
        SELECT MAX(tsh.change_date)  -- Get the latest accepted change_date for tasks in the project
        FROM TaskStatusHistory tsh
        WHERE 
            tsh.status = 'accepted' 
            AND tsh.task_id IN (
                SELECT t.task_id
                FROM Tasks t
                WHERE t.project_id = Projects.project_id
            )
    )
WHERE 
    project_id IN (SELECT project_id FROM AcceptedProjects);




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
            TaskStatusHistory tsh ON t.task_id = tsh.task_id
        WHERE 
            tsh.status != 'accepted'  -- Only consider tasks that are not marked as 'accepted' (non-closed tasks)
    );


   
   
-- 12. Assign given project task (using task name as identifier) to an employee which has minimum tasks with open status.


CREATE FUNCTION dbo.GetMinOpenTasks() 
RETURNS INT
AS
BEGIN
    DECLARE @min_open_tasks INT;

    -- Get the minimum task count of open tasks (status != 'accepted') assigned to any employee
    SELECT @min_open_tasks = MIN(task_count)
    FROM (
        SELECT 
            assigned_to, 
            COUNT(t.task_id) AS task_count
        FROM 
            dbo.Tasks t
        JOIN
            dbo.TaskStatusHistory tsh ON t.task_id = tsh.task_id
        WHERE 
            tsh.status != 'accepted'  -- Considering non-closed tasks only
        GROUP BY 
            assigned_to
    ) AS task_counts;

    RETURN @min_open_tasks;
END;

--GET LIST OF ALL EMPLOYEES WITH MINIMUM AMOUNT OF NON-CLOSED TASKS AND THEIR INFORMATION
SELECT * 
FROM Employees
WHERE employee_id IN (
    SELECT assigned_to
    FROM dbo.Tasks t
    JOIN dbo.TaskStatusHistory tsh ON t.task_id = tsh.task_id
    WHERE tsh.status != 'accepted'  -- Only consider tasks that are not closed (non-accepted)
    GROUP BY assigned_to
    HAVING COUNT(t.task_id) = dbo.GetMinOpenTasks()
);


-- I decided to choose the first employee 
-- Assign task to an employee with the least open tasks (non-closed tasks)
UPDATE dbo.Tasks
SET 
    assigned_to = (
        SELECT TOP 1 assigned_to
        FROM dbo.Tasks t
        JOIN dbo.TaskStatusHistory tsh ON t.task_id = tsh.task_id
        WHERE tsh.status != 'accepted'  -- Consider only non-closed tasks
        GROUP BY assigned_to
        HAVING COUNT(t.task_id) = dbo.GetMinOpenTasks()  -- Use the function to get the minimum open tasks
    )
WHERE 
    task_name = 'Initial Setup';


-- I decided to choose the first employee 
-- Assign task to an employee with the least open tasks (non-closed tasks)
UPDATE dbo.Tasks
SET 
    assigned_to = (
        SELECT TOP 1 assigned_to
        FROM dbo.Tasks t
        JOIN dbo.TaskStatusHistory tsh ON t.task_id = tsh.task_id
        WHERE tsh.status != 'accepted'  -- Consider only non-closed tasks
        GROUP BY assigned_to
        HAVING COUNT(t.task_id) = dbo.GetMinOpenTasks()  -- Use the function to get the minimum open tasks
    )
WHERE 
    task_name = 'Initial Setup';



-- ALTERNATIVE APPROACH 

-- Alternative approach using CTE to assign task to employee with least open tasks

WITH MinOpenTasks AS (
    SELECT 
        t.assigned_to, 
        COUNT(t.task_id) AS open_task_count
    FROM 
        dbo.Tasks t
    JOIN 
        dbo.TaskStatusHistory tsh ON t.task_id = tsh.task_id
    WHERE 
        tsh.status != 'accepted'  -- Consider only non-closed tasks (status != 'accepted')
    GROUP BY 
        t.assigned_to
), 

MinCount AS (
    SELECT 
        MIN(open_task_count) AS min_open_tasks
    FROM 
        MinOpenTasks
)

-- Select all employees who have the minimum number of open tasks
, EligibleEmployees AS (
    SELECT 
        assigned_to
    FROM 
        MinOpenTasks
    WHERE 
        open_task_count = (SELECT min_open_tasks FROM MinCount)
)
--SELECT * FROM EligibleEmployees;
-- Step 3: Assign the task to one of the employees with the fewest open tasks
UPDATE dbo.Tasks
SET 
    assigned_to = (SELECT TOP 1 assigned_to FROM EligibleEmployees)
WHERE 
    task_name = 'Initial Setup';



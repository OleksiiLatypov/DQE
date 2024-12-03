CREATE DATABASE CompanyDB;
USE CompanyDB



CREATE TABLE Employees (
	employee_id INT PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	job_title VARCHAR(50),
	department VARCHAR(50)
);



CREATE TABLE Projects (
	project_id INT PRIMARY KEY,
	project_name VARCHAR(100) NOT NULL,
	creation_date DATE NOT NULL,
	state VARCHAR(50) CHECK(state IN ('open', 'closed')),
	close_date DATE
);



CREATE TABLE EmployeeRoles (
    employee_role_id INT PRIMARY KEY IDENTITY(1,1),
    employee_id INT,
    project_id INT,
    employee_role VARCHAR(50),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id)
);



CREATE TABLE Tasks (
	task_id INT PRIMARY KEY,
	task_name VARCHAR(100) NOT NULL,
	project_id INT NOT NULL,
	assigned_to INT NOT NULL,
	deadline DATE,
	status VARCHAR(50) CHECK (status IN ('open', 'done', 'need work', 'accepted')),
	FOREIGN KEY (project_id) REFERENCES Projects(project_id),
	FOREIGN KEY (assigned_to) REFERENCES Employees(employee_id)
);



CREATE TABLE TaskStatusHistory (
	history_id INT PRIMARY KEY IDENTITY(1,1),
	task_id INT NOT NULL,
	status VARCHAR(50) CHECK (status IN ('open', 'done', 'need work', 'accepted')),
	change_date DATE NOT NULL,
	change_by INT NOT NULL,
	FOREIGN KEY (task_id) REFERENCES Tasks(task_id),
	FOREIGN KEY (change_by) REFERENCES Employees(employee_id)	
);




--insert data into Employees table
INSERT INTO Employees (employee_id, first_name, last_name, job_title, department)
VALUES 
(1, 'John', 'Doe', 'Developer', 'IT'),
(2, 'Jane', 'Smith', 'Project Manager', 'Operations'),
(3, 'Alice', 'Johnson', 'Tester', 'Quality Assurance'),
(4, 'Bob', 'Brown', 'Developer', 'IT'),
(5, 'Emma', 'Davis', 'Designer', 'Creative'),
(6, 'Tom', 'Wilson', 'Business Analyst', 'Operations'),
(7, 'Laura', 'Taylor', 'Software Engineer', 'IT'),
(8, 'Daniel', 'Lee', 'System Architect', 'IT'),
(9, 'Sarah', 'Moore', 'Quality Engineer', 'Quality Assurance'),
(10, 'Chris', 'Evans', 'Product Manager', 'Operations');


--insert data into Projects table
INSERT INTO Projects (project_id, project_name, creation_date, state, close_date)
VALUES 
(1, 'Project Alpha', '2024-01-01', 'open', NULL),
(2, 'Project Beta', '2024-02-15', 'open', NULL),
(3, 'Project Gamma', '2024-03-10', 'closed', '2024-06-10'),
(4, 'Project Delta', '2024-04-01', 'open', NULL),
(5, 'Project Epsilon', '2024-05-20', 'open', NULL),
(6, 'Project Zeta', '2024-06-15', 'open', NULL),
(7, 'Project Eta', '2024-07-01', 'open', NULL),
(8, 'Project Theta', '2024-07-15', 'closed', '2024-10-15'),
(9, 'Project Iota', '2024-08-01', 'open', NULL),
(10, 'Project Kappa', '2024-08-20', 'open', NULL);

INSERT INTO Projects (project_id, project_name, creation_date, state, close_date)
VALUES 
(11, 'Project Lambda', '2024-09-01', 'open', NULL);




-- insert data into EmployeeRoles table
INSERT INTO EmployeeRoles (employee_id, project_id, employee_role)
VALUES 
(1, 1, 'Lead Developer'),         
(1, 2, 'Project Manager'),        
(3, 2, 'Tester'),                 
(4, 2, 'Developer'),              
(2, 3, 'Designer'),               
(6, 4, 'Business Analyst'),       
(7, 5, 'Software Engineer'),      
(8, 6, 'System Architect'),       
(9, 7, 'Quality Engineer'),       
(10, 8, 'Product Manager'),       
(1, 9, 'Consultant'),             
(2, 10, 'Advisor');    
          
INSERT INTO EmployeeRoles (employee_id, project_id, employee_role)
VALUES 
(7, 7, 'Developer'); 


INSERT INTO EmployeeRoles (employee_id, project_id, employee_role)
VALUES 
(NULL, 5, 'Frontend Developer '), -- Role with no employee assigned
(NULL, 9, 'Lead Developer'); -- Another role with no employee assigned





--insert data into Tasks table
INSERT INTO Tasks (task_id, task_name, project_id, assigned_to, status, deadline)
VALUES 
(1, 'Database Design', 1, 1, 'open', '2025-02-15'),
(2, 'Requirement Analysis', 1, 2, 'done', '2025-01-25'),
(3, 'UI Design', 2, 5, 'need work', '2024-12-10'),
(4, 'Backend API Development', 2, 4, 'open', '2024-12-30'),
(5, 'Testing', 1, 3, 'accepted', '2024-11-20'),
(6, 'Business Requirements Gathering', 6, 6, 'done', '2024-10-01'),
(7, 'Backend Service Development', 7, 7, 'open', '2024-08-01'),
(8, 'Architecture Review', 8, 8, 'accepted', '2024-11-10'),
(9, 'Testing Framework Setup', 9, 9, 'need work', '2024-12-01'),
(10, 'Feature Planning', 10, 10, 'open', '2025-09-10');

-- Insert additional tasks to give some employees more than one task
INSERT INTO Tasks (task_id, task_name, project_id, assigned_to, status, deadline)
VALUES 
-- Assign multiple tasks to employee_id 1
(11, 'Database Optimization', 1, 1, 'open', '2025-03-01'),
(12, 'Query Performance Tuning', 1, 1, 'need work', '2025-03-15'),

-- Assign tasks to employee_id 2
(13, 'Stakeholder Meeting', 2, 2, 'open', '2025-04-01'),
(14, 'Requirement Documentation', 2, 2, 'done', '2025-01-20'),

-- Assign tasks to employee_id 3
(15, 'Automated Testing Setup', 3, 3, 'open', '2024-12-20'),
(16, 'Regression Testing', 3, 3, 'accepted', '2025-01-05');

INSERT INTO Tasks (task_id, task_name, project_id, assigned_to, status, deadline)
VALUES 
(17, 'Final Review', 8, 8, 'accepted', '2024-11-15');

INSERT INTO Tasks (task_id, task_name, project_id, assigned_to, status, deadline)
VALUES 
(18, 'Initial Setup', 11, 4, 'accepted', '2024-10-01'),
(19, 'Requirement Approval', 11, 2, 'accepted', '2024-10-15'),
(20, 'Design Review', 11, 7, 'accepted', '2024-11-01');




--insert data into TaskStatusHistory table
INSERT INTO TaskStatusHistory (task_id, status, change_date, change_by)
VALUES 
(1, 'open', '2024-01-01', 1),  
(2, 'done', '2024-01-02', 2),  
(3, 'need work', '2024-02-15', 5),  
(4, 'open', '2024-02-20', 4),  
(5, 'accepted', '2024-01-15', 3), 
(6, 'done', '2024-06-15', 6),  
(7, 'open', '2024-07-01', 7), 
(8, 'accepted', '2024-07-10', 8), 
(9, 'need work', '2024-08-01', 9), 
(10, 'open', '2024-08-20', 10);


-- Insert status history for the new tasks
INSERT INTO TaskStatusHistory (task_id, status, change_date, change_by)
VALUES 
-- Status history for task_id 11 (assigned to employee_id 1)
(11, 'open', '2025-01-15', 1), -- Initial status change by employee 1

-- Status history for task_id 12 (assigned to employee_id 1)
(12, 'need work', '2025-02-20', 1), -- Status updated by employee 1

-- Status history for task_id 13 (assigned to employee_id 2)
(13, 'open', '2025-02-25', 2), -- Initial status change by employee 2

-- Status history for task_id 14 (assigned to employee_id 2)
(14, 'done', '2025-01-20', 2), -- Status updated by employee 2

-- Status history for task_id 15 (assigned to employee_id 3)
(15, 'open', '2024-11-15', 3), -- Initial status change by employee 3

-- Status history for task_id 16 (assigned to employee_id 3)
(16, 'accepted', '2025-01-05', 3); -- Status updated by employee 3

-- Insert TaskStatusHistory entries for Project Lambda
-- Task 18: Initial Setup
INSERT INTO TaskStatusHistory (task_id, status, change_date, change_by)
VALUES 
(18, 'open', '2024-09-01', 4),  -- Task opened on project creation by employee 4
(18, 'accepted', '2024-10-01', 4);  -- Task accepted by employee 4 on deadline

-- Task 19: Requirement Approval
INSERT INTO TaskStatusHistory (task_id, status, change_date, change_by)
VALUES 
(19, 'open', '2024-09-01', 2),  -- Task opened on project creation by employee 2
(19, 'accepted', '2024-10-15', 2);  -- Task accepted by employee 2 on deadline

-- Task 20: Design Review
INSERT INTO TaskStatusHistory (task_id, status, change_date, change_by)
VALUES 
(20, 'open', '2024-09-01', 7),  -- Task opened on project creation by employee 7
(20, 'accepted', '2024-11-01', 7);  -- Task accepted by employee 7 on deadline











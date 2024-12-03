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




-- Insert data into Tasks table
INSERT INTO Tasks (task_id, task_name, project_id, assigned_to, deadline)
VALUES 
(1, 'Database Design', 1, 1, '2025-02-15'),
(2, 'Requirement Analysis', 1, 2, '2025-01-25'),
(3, 'UI Design', 2, 5, '2024-12-10'),
(4, 'Backend API Development', 2, 4, '2024-12-30'),
(5, 'Testing', 1, 3, '2024-11-20'),
(6, 'Business Requirements Gathering', 6, 6, '2024-10-01'),
(7, 'Backend Service Development', 7, 7, '2024-08-01'),
(8, 'Architecture Review', 8, 8, '2024-11-10'),
(9, 'Testing Framework Setup', 9, 9, '2024-12-01'),
(10, 'Feature Planning', 10, 10, '2025-09-10'),
(11, 'Database Optimization', 1, 1, '2025-03-01'),
(12, 'Query Performance Tuning', 1, 1, '2025-03-15'),
(13, 'Stakeholder Meeting', 2, 2, '2025-04-01'),
(14, 'Requirement Documentation', 2, 2, '2025-01-20'),
(15, 'Automated Testing Setup', 3, 3, '2024-12-20'),
(16, 'Regression Testing', 3, 3, '2025-01-05'),
(17, 'Final Review', 8, 8, '2024-11-15'),
(18, 'Initial Setup', 11, 4, '2024-10-01'),
(19, 'Requirement Approval', 11, 2, '2024-10-15'),
(20, 'Design Review', 11, 7, '2024-11-01');



-- Insert data into TaskStatusHistory table
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
(10, 'open', '2024-08-20', 10),
(11, 'open', '2025-01-15', 1),
(12, 'need work', '2025-02-20', 1),
(13, 'open', '2025-02-25', 2),
(14, 'done', '2025-01-20', 2),
(15, 'open', '2024-11-15', 3),
(16, 'accepted', '2025-01-05', 3),
(17, 'accepted', '2024-11-15', 8),
(18, 'accepted', '2024-10-01', 4),
(19, 'accepted', '2024-10-15', 2),
(20, 'accepted', '2024-11-01', 7);

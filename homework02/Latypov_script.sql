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
	employee_id INT,
	project_id INT,
	employee_role VARCHAR(50),
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
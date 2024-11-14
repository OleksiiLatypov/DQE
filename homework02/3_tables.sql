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


CREATE TABLE EmployeeProjects (
	employee_id INT NOT NULL,
	project_id INT NOT NULL,
	employee_role VARCHAR(50),
	PRIMARY KEY (employee_id, project_id),
	FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
	FOREIGN KEY (project_id) REFERENCES Projects(project_id)	
);

CREATE TABLE Tasks (
	task_id INT PRIMARY KEY,
	task_name VARCHAR(100) NOT NULL,
	project_id INT NOT NULL,
	assigned_to INT NOT NULL,
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


-- Insert employees
INSERT INTO Employees (employee_id, first_name, last_name, job_title, department)
VALUES (1, 'John', 'Doe', 'Developer', 'IT');

INSERT INTO Employees (employee_id, first_name, last_name, job_title, department)
VALUES (2, 'Jane', 'Smith', 'Project Manager', 'Operations');

INSERT INTO Employees (employee_id, first_name, last_name, job_title, department)
VALUES (3, 'Alice', 'Johnson', 'Tester', 'Quality Assurance');

INSERT INTO Employees (employee_id, first_name, last_name, job_title, department)
VALUES (4, 'Bob', 'Brown', 'Developer', 'IT');

INSERT INTO Employees (employee_id, first_name, last_name, job_title, department)
VALUES (5, 'Emma', 'Davis', 'Designer', 'Creative');

--------------
INSERT INTO Employees (employee_id, first_name, last_name, job_title, department)
VALUES (6, 'Tom', 'Wilson', 'Business Analyst', 'Operations');

INSERT INTO Employees (employee_id, first_name, last_name, job_title, department)
VALUES (7, 'Laura', 'Taylor', 'Software Engineer', 'IT');

INSERT INTO Employees (employee_id, first_name, last_name, job_title, department)
VALUES (8, 'Daniel', 'Lee', 'System Architect', 'IT');

INSERT INTO Employees (employee_id, first_name, last_name, job_title, department)
VALUES (9, 'Sarah', 'Moore', 'Quality Engineer', 'Quality Assurance');

INSERT INTO Employees (employee_id, first_name, last_name, job_title, department)
VALUES (10, 'Chris', 'Evans', 'Product Manager', 'Operations');







-- Insert projects
INSERT INTO Projects (project_id, project_name, creation_date, state, close_date)
VALUES (1, 'Project Alpha', '2024-01-01', 'open', NULL);

INSERT INTO Projects (project_id, project_name, creation_date, state, close_date)
VALUES (2, 'Project Beta', '2024-02-15', 'open', NULL);

INSERT INTO Projects (project_id, project_name, creation_date, state, close_date)
VALUES (3, 'Project Gamma', '2024-03-10', 'closed', '2024-06-10');

INSERT INTO Projects (project_id, project_name, creation_date, state, close_date)
VALUES (4, 'Project Delta', '2024-04-01', 'open', NULL);

INSERT INTO Projects (project_id, project_name, creation_date, state, close_date)
VALUES (5, 'Project Epsilon', '2024-05-20', 'open', NULL);


----------
INSERT INTO Projects (project_id, project_name, creation_date, state, close_date)
VALUES (6, 'Project Zeta', '2024-06-15', 'open', NULL);

INSERT INTO Projects (project_id, project_name, creation_date, state, close_date)
VALUES (7, 'Project Eta', '2024-07-01', 'open', NULL);

INSERT INTO Projects (project_id, project_name, creation_date, state, close_date)
VALUES (8, 'Project Theta', '2024-07-15', 'closed', '2024-10-15');

INSERT INTO Projects (project_id, project_name, creation_date, state, close_date)
VALUES (9, 'Project Iota', '2024-08-01', 'open', NULL);

INSERT INTO Projects (project_id, project_name, creation_date, state, close_date)
VALUES (10, 'Project Kappa', '2024-08-20', 'open', NULL);



-- Assign employees to projects with roles
INSERT INTO EmployeeProjects (employee_id, project_id, employee_role)
VALUES (1, 1, 'Lead Developer');

INSERT INTO EmployeeProjects (employee_id, project_id, employee_role)
VALUES (2, 1, 'Project Manager');

INSERT INTO EmployeeProjects (employee_id, project_id, employee_role)
VALUES (3, 1, 'Tester');

INSERT INTO EmployeeProjects (employee_id, project_id, employee_role)
VALUES (4, 2, 'Developer');

INSERT INTO EmployeeProjects (employee_id, project_id, employee_role)
VALUES (5, 2, 'Designer');

-------
INSERT INTO EmployeeProjects (employee_id, project_id, employee_role)
VALUES (6, 6, 'Business Analyst');

INSERT INTO EmployeeProjects (employee_id, project_id, employee_role)
VALUES (7, 7, 'Software Engineer');

INSERT INTO EmployeeProjects (employee_id, project_id, employee_role)
VALUES (8, 8, 'System Architect');

INSERT INTO EmployeeProjects (employee_id, project_id, employee_role)
VALUES (9, 9, 'Quality Engineer');

INSERT INTO EmployeeProjects (employee_id, project_id, employee_role)
VALUES (10, 10, 'Product Manager');





-- Insert tasks assigned to employees
INSERT INTO Tasks (task_id, task_name, project_id, assigned_to, status)
VALUES (1, 'Database Design', 1, 1, 'open');

INSERT INTO Tasks (task_id, task_name, project_id, assigned_to, status)
VALUES (2, 'Requirement Analysis', 1, 2, 'done');

INSERT INTO Tasks (task_id, task_name, project_id, assigned_to, status)
VALUES (3, 'UI Design', 2, 5, 'need work');

INSERT INTO Tasks (task_id, task_name, project_id, assigned_to, status)
VALUES (4, 'Backend API Development', 2, 4, 'open');

INSERT INTO Tasks (task_id, task_name, project_id, assigned_to, status)
VALUES (5, 'Testing', 1, 3, 'accepted');

-------------
INSERT INTO Tasks (task_id, task_name, project_id, assigned_to, status)
VALUES (6, 'Business Requirements Gathering', 6, 6, 'done');

INSERT INTO Tasks (task_id, task_name, project_id, assigned_to, status)
VALUES (7, 'Backend Service Development', 7, 7, 'open');

INSERT INTO Tasks (task_id, task_name, project_id, assigned_to, status)
VALUES (8, 'Architecture Review', 8, 8, 'accepted');

INSERT INTO Tasks (task_id, task_name, project_id, assigned_to, status)
VALUES (9, 'Testing Framework Setup', 9, 9, 'need work');

INSERT INTO Tasks (task_id, task_name, project_id, assigned_to, status)
VALUES (10, 'Feature Planning', 10, 10, 'open');




-- Track task status changes
INSERT INTO TaskStatusHistory (task_id, status, change_date, change_by)
VALUES (1, 'open', '2024-01-05', 1);

INSERT INTO TaskStatusHistory (task_id, status, change_date, change_by)
VALUES (2, 'done', '2024-01-10', 2);

INSERT INTO TaskStatusHistory (task_id, status, change_date, change_by)
VALUES (3, 'need work', '2024-03-15', 5);

INSERT INTO TaskStatusHistory (task_id, status, change_date, change_by)
VALUES (4, 'open', '2024-04-01', 4);

INSERT INTO TaskStatusHistory (task_id, status, change_date, change_by)
VALUES (5, 'accepted', '2024-02-20', 3);

----------
INSERT INTO TaskStatusHistory (task_id, status, change_date, change_by)
VALUES (6, 'done', '2024-06-20', 6);

INSERT INTO TaskStatusHistory (task_id, status, change_date, change_by)
VALUES (7, 'open', '2024-07-03', 7);

INSERT INTO TaskStatusHistory (task_id, status, change_date, change_by)
VALUES (8, 'accepted', '2024-08-15', 8);

INSERT INTO TaskStatusHistory (task_id, status, change_date, change_by)
VALUES (9, 'need work', '2024-08-05', 9);

INSERT INTO TaskStatusHistory (task_id, status, change_date, change_by)
VALUES (10, 'open', '2024-08-25', 10);











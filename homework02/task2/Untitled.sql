--CREATE DATABASE CompanyDB;
--USE CompanyDB



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













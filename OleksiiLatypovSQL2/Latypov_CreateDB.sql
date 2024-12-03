CREATE DATABASE CompanyDB;
USE CompanyDB;

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
    state VARCHAR(50) CHECK (state IN ('open', 'closed')),
    close_date DATE,
    CONSTRAINT chk_close_date_if_closed CHECK (
        (state = 'closed' AND close_date IS NOT NULL) OR (state = 'open' AND close_date IS NULL) -- constraint ensuring the close_date is not NULL if the state is 'closed' and is NULL if the state is 'open'.
    )
);




CREATE TABLE EmployeeRoles (
    employee_role_id INT PRIMARY KEY IDENTITY(1,1),
    employee_id INT,
    project_id INT,
    employee_role VARCHAR(50),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id)
);

-- Tasks Table
CREATE TABLE Tasks (
    task_id INT PRIMARY KEY,                       -- task_id as the primary key
    task_name VARCHAR(100) NOT NULL,                -- task name
    project_id INT NOT NULL,                        -- associated project_id
    assigned_to INT NOT NULL,                       -- assigned employee's ID
    deadline DATE,                                  -- task deadline
    FOREIGN KEY (project_id) REFERENCES Projects(project_id),  -- foreign key to Projects
    FOREIGN KEY (assigned_to) REFERENCES Employees(employee_id) -- foreign key to Employees
);

-- TaskStatusHistory Table
CREATE TABLE TaskStatusHistory (
    history_id INT IDENTITY(1,1) PRIMARY KEY,      -- history_id as the primary key (auto-increment)
    task_id INT,                                    -- task_id to reference which task this history record is for
    status VARCHAR(50) CHECK (status IN ('open', 'done', 'need work', 'accepted')),  -- task status
    change_date DATE NOT NULL,                      -- date of status change
    change_by INT NOT NULL,                         -- employee who made the change
    FOREIGN KEY (task_id) REFERENCES Tasks(task_id),   -- foreign key to Tasks table
    FOREIGN KEY (change_by) REFERENCES Employees(employee_id)  -- foreign key to Employees table
);




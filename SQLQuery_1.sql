CREATE DATABASE TestDB;


SELECT Name, create_date from sys.databases;



CREATE TABLE Persons(
    PersonID INT,
    Firstname VARCHAR(50),
    Lastname VARCHAR(50),
    Address VARCHAR(50),
    City VARCHAR(50)
);


SELECT * FROM INFORMATION_SCHEMA.TABLES;


SELECT COLUMN_NAME, DATA_TYPE
    FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_NAME = 'Persons';


EXEC sp_rename 'Persons', 'People'; --rename table name
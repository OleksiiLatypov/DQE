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

EXEC sp_rename 'People', 'Persons';


ALTER TABLE Persons
ADD Email VARCHAR(50);

ALTER TABLE Persons
DROP COLUMN Email;

INSERT INTO Persons 
VALUES (2, 'Olena', 'Ovcharenko', 'Estonska 18', 'Kyiv'), (2, 'Evgeniia', 'Hryzun', 'Estonska 18', 'Kyiv');

SELECT * FROM Persons;

UPDATE Persons
SET Firstname = 'Oleksii'
WHERE PersonID = 1;


INSERT INTO Persons
VALUES (4, 'Mariia', 'Ovcharenko', 'Zoryana', 'Kyiv');

BEGIN TRAN

INSERT INTO Persons (PersonID, Firstname, Lastname, Address, City)
VALUES (5, 'Nataliia', 'Ovcharenko', 'Zoryana', 'Kyiv');

ROLLBACK

UPDATE Persons
SET City= 'Kyiv'
WHERE Firstname='Nataliia';

INSERT INTO Persons (PersonID, Firstname, Lastname, Address, City)
VALUES ('6', 'Darya', 'Latypova', 'Ronald Reygen', 'Kryvyi Rig');

DELETE FROM Persons
WHERE PersonID='6';

UPDATE Persons
SET City='Kyiv'
WHERE City='Kuiv';

SELECT * INTO People
FROM Persons
WHERE 1=0;

SELECT TOP(3) * FROM Persons;


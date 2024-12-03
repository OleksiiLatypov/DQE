CREATE DATABASE BooksDB;
USE BooksDB



CREATE TABLE Authors(
	author_id INT PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	birthdate DATE
);


CREATE TABLE Books(
	book_id INT PRIMARY KEY,
	title VARCHAR(100) NOT NULL,
	genre VARCHAR(100),
	published_date DATE,
	author_id INT,
	FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);


CREATE TABLE Members (
    member_id INT,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(100),
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(10) CHECK (LEN(phone) = 10 AND phone NOT LIKE '%[^0-9]%'),  -- Length between 10 and 14 digits, only numeric
    CONSTRAINT PK_Members PRIMARY KEY (member_id)  -- PRIMARY KEY constraint with a custom name
);



CREATE TABLE Loans (
	loan_id INT PRIMARY KEY,
	book_id INT,
	member_id INT,
	loan_date DATE,
	return_date DATE,
	CONSTRAINT FK_Book FOREIGN KEY (book_id) REFERENCES Books(book_id),
	CONSTRAINT FK_Member FOREIGN KEY (member_id) REFERENCES Members(member_id)
);


INSERT INTO Authors (author_id, name, birthdate)
VALUES (1, 'J.K. Rowling', '1965-07-31');

INSERT INTO Authors (author_id, name, birthdate)
VALUES (2, 'Ivan Franko', '1856-08-27');

INSERT INTO Authors (author_id, name, birthdate)
VALUES (3, 'Lesia Ukrainka', '1913-08-01');


INSERT INTO Authors (author_id, name, birthdate)
VALUES (6, 'Agatha Christie', '1890-09-15');



INSERT INTO Books (book_id, title, genre, published_date, author_id)
VALUES (1, 'Harry Potter and the Philosophers Stone', 'Fantasy', '1997-06-26', 1);

INSERT INTO Books (book_id, title, genre, published_date, author_id)
VALUES (2, 'Zahar Berkut', 'Story', '1882-11-15', 2);

INSERT INTO Books (book_id, title, genre, published_date, author_id)
VALUES (3, 'Lisova Pisnya', 'Feerie', '1911-01-01', 3);

INSERT INTO Books (book_id, title, genre, published_date, author_id)
VALUES (10, 'Murder on the Orient Express', 'Mystery', '1934-01-01', 6);




INSERT INTO Members (member_id, name, address, email, phone)
VALUES (1, 'Alice Smith', '123 Maple St', '55516662349080');

INSERT INTO Members (member_id, name, address, email, phone)
VALUES (2, 'Bob Johnson', '456 Oak St', 'bobby_johny@example.com', '555567800');

-- Insert additional members
INSERT INTO Members (member_id, name, address, email, phone) 
VALUES 
(3, 'Carol Davis', '789 Pine St', 'carol.davis@example.com', '5558765432'),
(4, 'David Martinez', '101 Elm St', 'david.martinez@example.com', '5559876543'),
(5, 'Eve Torres', '202 Birch St', 'eve.torres@example.com', '5554567890'),
(6, 'Frank Williams', '303 Cedar St', 'frank.williams@example.com', '5553216547'),
(7, 'Grace Lee', '404 Walnut St', 'grace.lee@example.com', '5552345678');

-- Insert additional loans
INSERT INTO Loans (loan_id, book_id, member_id, loan_date, return_date) VALUES (1, 1, 1, '2023-10-01', '2023-10-15');
INSERT INTO Loans (loan_id, book_id, member_id, loan_date, return_date) VALUES (2, 2, 2, '2023-10-05', NULL);


INSERT INTO Loans (loan_id, book_id, member_id, loan_date, return_date) 
VALUES 
(3, 1, 3, '2023-10-07', '2023-10-21'),
(4, 2, 4, '2023-10-09', NULL),  -- Book not returned yet
(5, 3, 5, '2023-10-12', '2023-10-26'),
(6, 1, 6, '2023-10-13', NULL),  -- Book not returned yet
(7, 2, 7, '2023-10-15', '2023-10-29');






















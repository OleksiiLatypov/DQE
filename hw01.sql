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
    phone VARCHAR(10) CHECK (LEN(phone) BETWEEN 10 AND 14 AND phone NOT LIKE '%[^0-9]%'),  -- Length between 10 and 14 digits, only numeric
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


INSERT INTO Books (book_id, title, genre, published_date, author_id)
VALUES (1, 'Harry Potter and the Philosophers Stone', 'Fantasy', '1997-06-26', 1);

INSERT INTO Books (book_id, title, genre, published_date, author_id)
VALUES (2, 'Zahar Berkut', 'Story', '1882-11-15', 2);

INSERT INTO Books (book_id, title, genre, published_date, author_id)
VALUES (3, 'Lisova Pisnya', 'Feerie', '1911-01-01', 3);


ALTER TABLE Members
ALTER COLUMN phone VARCHAR(255);

ALTER TABLE Members
ADD CONSTRAINT CK_Members_Phone_Numeric CHECK (phone NOT LIKE '%[^0-9]%');


INSERT INTO Members (member_id, name, address, phone)
VALUES (1, 'Alice Smith', '123 Maple St', '55516662349080');




















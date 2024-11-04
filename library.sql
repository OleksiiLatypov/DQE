-- Create the database
CREATE DATABASE LibraryDB;
USE LibraryDB;

-- Create Authors table
CREATE TABLE Authors (
    author_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    birthdate DATE
);

-- Create Books table
CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    genre VARCHAR(50),
    published_date DATE,
    author_id INT,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);

-- Create Members table
CREATE TABLE Members (
    member_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(200),
    phone_number VARCHAR(15)
);

-- Create Loans table
CREATE TABLE Loans (
    loan_id INT PRIMARY KEY,
    book_id INT,
    member_id INT,
    loan_date DATE,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);


-- Insert data into Authors
INSERT INTO Authors (author_id, name, birthdate) VALUES (1, 'J.K. Rowling', '1965-07-31');
INSERT INTO Authors (author_id, name, birthdate) VALUES (2, 'George R.R. Martin', '1948-09-20');
INSERT INTO Authors (author_id, name, birthdate) VALUES (3, 'J.R.R. Tolkien', '1892-01-03');

-- Insert data into Books
INSERT INTO Books (book_id, title, genre, published_date, author_id) VALUES (1, 'Harry Potter and the Philosopher''s Stone', 'Fantasy', '1997-06-26', 1);
INSERT INTO Books (book_id, title, genre, published_date, author_id) VALUES (2, 'A Game of Thrones', 'Fantasy', '1996-08-06', 2);
INSERT INTO Books (book_id, title, genre, published_date, author_id) VALUES (3, 'The Hobbit', 'Fantasy', '1937-09-21', 3);

-- Insert data into Members
INSERT INTO Members (member_id, name, address, phone_number) VALUES (1, 'Alice Smith', '123 Maple St', '555-1234');
INSERT INTO Members (member_id, name, address, phone_number) VALUES (2, 'Bob Johnson', '456 Oak St', '555-5678');

-- Insert data into Loans
INSERT INTO Loans (loan_id, book_id, member_id, loan_date, return_date) VALUES (1, 1, 1, '2023-10-01', '2023-10-15');
INSERT INTO Loans (loan_id, book_id, member_id, loan_date, return_date) VALUES (2, 2, 2, '2023-10-05', NULL);


-- 1. Find all unique genres in the Books table
SELECT DISTINCT genre FROM Books;

-- 2. Find all books written by 'J.K. Rowling'
SELECT title FROM Books
WHERE author_id = (SELECT author_id FROM Authors WHERE name = 'J.K. Rowling');

-- 3. Find members who borrowed books in October 2023
SELECT Members.name, Loans.loan_date FROM Members
JOIN Loans ON Members.member_id = Loans.member_id
WHERE Loans.loan_date BETWEEN '2023-10-01' AND '2023-10-31';

-- 4. Count the total number of books available in the library
SELECT COUNT(*) AS total_books FROM Books;

-- 5. Get all loan records, showing the book title and member name
SELECT Loans.loan_id, Books.title, Members.name, Loans.loan_date, Loans.return_date
FROM Loans
JOIN Books ON Loans.book_id = Books.book_id
JOIN Members ON Loans.member_id = Members.member_id;

-- 6. List all authors who have written more than one book
SELECT Authors.name, COUNT(Books.book_id) AS books_written
FROM Authors
JOIN Books ON Authors.author_id = Books.author_id
GROUP BY Authors.name
HAVING COUNT(Books.book_id) > 1;

-- 7. Find the oldest book in the library
SELECT title, MIN(published_date) AS oldest_book FROM Books;

-- 8. List all members who have not returned their books
SELECT Members.name, Books.title, Loans.loan_date
FROM Members
JOIN Loans ON Members.member_id = Loans.member_id
JOIN Books ON Loans.book_id = Books.book_id
WHERE Loans.return_date IS NULL;

-- 9. Find books with titles that start with 'A'
SELECT title FROM Books
WHERE title LIKE 'A%';

-- 10. Calculate the average loan duration for returned books
SELECT AVG(DATEDIFF(day, loan_date, return_date)) AS avg_loan_duration
FROM Loans
WHERE return_date IS NOT NULL;

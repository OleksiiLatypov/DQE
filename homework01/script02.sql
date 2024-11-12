-- Selects all unique genres from the Books table that start with the letter 'F'
SELECT DISTINCT genre FROM Books
WHERE genre LIKE 'F%';



-- Select the genre, title, and publish date for books that have not been loaned
SELECT genre,
	title,
	published_date 
FROM books
WHERE book_id NOT IN (
    SELECT book_id FROM loans
);



-- Selects each book title, author name, genre, and the total number of books by the same author
SELECT b.title, 
    a.name AS author_name, 
    b.genre,
    COUNT(b.book_id) OVER (PARTITION BY a.author_id) AS total_books_by_author  -- Window function to count books per author
FROM 
    Books b
INNER JOIN Authors a ON
	b.author_id = a.author_id
ORDER BY total_books_by_author DESC;




--Calculates the average duration across all loans for each book
SELECT b.title, AVG(DATEDIFF(day, l.loan_date, l.return_date)) AS avg_loan_duration
FROM Loans l
JOIN Books b ON
	l.book_id = b.book_id
WHERE l.return_date IS NOT NULL  -- consider returned loans
GROUP BY b.title;



-- Select members without loans
SELECT m.name,
	m.email,
	m.phone
FROM Members m
LEFT JOIN Loans l ON
	m.member_id = l.member_id
WHERE l.loan_id IS NULL;



-- Select unique books currently on loan that were published before January 1, 1900
SELECT DISTINCT b.title,
	b.genre,
	b.published_date  
FROM Books b 
JOIN Loans l ON
	b.book_id = l.book_id
WHERE l.return_date IS NULL AND b.published_date < '1900-01-01';



-- Select the top most popular genre based on the number of loans
SELECT TOP 1
	b.genre,
	COUNT(l.loan_id) AS loan_count
FROM Books b
JOIN Loans l ON
	b.book_id = l.book_id
GROUP BY b.genre
ORDER BY loan_count DESC;



-- Select member details along with loan dates for loans made between '2023-10-07' and '2023-10-15'
SELECT m.name,
	m.email,
	m.address,
	l.loan_date
FROM Members m
JOIN Loans l ON
	m.member_id = l.member_id
WHERE l.loan_date > '2023-10-07' AND l.loan_date < '2023-10-15'
ORDER BY m.name ASC;



-- Select details about books currently loaned (not returned yet) along with member information
SELECT b.title AS book_title,
	m.name AS member_name,
	m.phone AS member_phone_number,
	l.loan_date,
	l.return_date 
FROM Members m
JOIN Loans l ON
	m.member_id = l.member_id
JOIN Books b ON l.book_id = b.book_id
WHERE l.return_date IS NULL;



-- Select the author's name and the count of loans for each author (most popular based on loans)
SELECT a.name AS author_name,
	COUNT(l.loan_id) AS most_popular_loan_author 
FROM Members m
JOIN Loans l ON
	m.member_id = l.member_id
JOIN Books b ON
	l.book_id = b.book_id
JOIN Authors a ON
	b.author_id = a.author_id
GROUP BY a.name
ORDER BY 2 DESC;









-- Library Management System Database
-- Create the database
DROP DATABASE IF EXISTS library_db;
CREATE DATABASE library_db;
USE library_db;

-- 1. Members Table (1-M relationship with Loans)
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    date_of_birth DATE,
    membership_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    membership_type ENUM('student', 'regular', 'senior') DEFAULT 'regular',
    status ENUM('active', 'expired', 'suspended') DEFAULT 'active',
    CONSTRAINT chk_email CHECK (email LIKE '%@%.%')
);

-- 2. Publishers Table (1-M relationship with Books)
CREATE TABLE publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address TEXT,
    city VARCHAR(50),
    country VARCHAR(50),
    website VARCHAR(100),
    established_year INT,
    CONSTRAINT unq_publisher_name UNIQUE (name)
);

-- 3. Authors Table (M-M relationship with Books)
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    nationality VARCHAR(50),
    birth_year INT,
    death_year INT,
    biography TEXT,
    CONSTRAINT unq_author_name UNIQUE (first_name, last_name)
);

-- 4. Book Categories Table (1-M relationship with Books)
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    parent_category_id INT,
    FOREIGN KEY (parent_category_id) REFERENCES categories(category_id)
);

-- 5. Books Table (Central entity with multiple relationships)
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(17) UNIQUE NOT NULL,
    title VARCHAR(200) NOT NULL,
    edition VARCHAR(20),
    publication_year INT,
    publisher_id INT NOT NULL,
    category_id INT NOT NULL,
    pages INT,
    language VARCHAR(30) DEFAULT 'English',
    description TEXT,
    total_copies INT NOT NULL DEFAULT 1,
    available_copies INT NOT NULL DEFAULT 1,
    shelf_location VARCHAR(20),
    added_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    CONSTRAINT chk_isbn CHECK (LENGTH(isbn) = 13 OR LENGTH(isbn) = 17),
    CONSTRAINT chk_copies CHECK (available_copies <= total_copies AND available_copies >= 0)
);

-- 6. Book-Author Junction Table (M-M relationship)
CREATE TABLE book_authors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE
);

-- 7. Loans Table (Connects Members and Books)
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    due_date DATE NOT NULL,
    return_date DATE,
    status ENUM('active', 'returned', 'overdue', 'lost') DEFAULT 'active',
    renewed_count INT DEFAULT 0,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    CONSTRAINT chk_due_date CHECK (due_date > loan_date),
    CONSTRAINT chk_return_date CHECK (return_date IS NULL OR return_date >= loan_date)
);

-- 8. Fines Table (1-1 relationship with Loans)
CREATE TABLE fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT UNIQUE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    issue_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    payment_date DATE,
    status ENUM('unpaid', 'paid', 'waived') DEFAULT 'unpaid',
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id),
    CONSTRAINT chk_fine_amount CHECK (amount >= 0)
);

-- 9. Reservations Table
CREATE TABLE reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    reservation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expiry_date DATETIME NOT NULL,
    status ENUM('pending', 'fulfilled', 'cancelled', 'expired') DEFAULT 'pending',
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    CONSTRAINT chk_reservation_expiry CHECK (expiry_date > reservation_date)
);

-- Insert sample data

-- Publishers
INSERT INTO publishers (name, address, city, country, website, established_year)
VALUES 
('Penguin Random House', '1745 Broadway, New York, NY 10019', 'New York', 'USA', 'https://www.penguinrandomhouse.com', 2013),
('HarperCollins', '195 Broadway, New York, NY 10007', 'New York', 'USA', 'https://www.harpercollins.com', 1989),
('Oxford University Press', 'Great Clarendon St, Oxford OX2 6DP', 'Oxford', 'UK', 'https://global.oup.com', 1586);

-- Categories
INSERT INTO categories (name, description)
VALUES 
('Fiction', 'Imaginary stories and narratives'),
('Science Fiction', 'Fiction dealing with futuristic concepts'),
('Biography', 'Non-fiction accounts of people\'s lives'),
('History', 'Records of past events');

INSERT INTO categories (name, description, parent_category_id)
VALUES 
('Fantasy', 'Fiction with magical elements', 1),
('Romance', 'Fiction focusing on love stories', 1),
('Military History', 'History of armed conflict', 4);

-- Authors
INSERT INTO authors (first_name, last_name, nationality, birth_year)
VALUES 
('George', 'Orwell', 'British', 1903),
('J.K.', 'Rowling', 'British', 1965),
('Yuval Noah', 'Harari', 'Israeli', 1976),
('Stephen', 'King', 'American', 1947);

-- Members
INSERT INTO members (first_name, last_name, email, phone, membership_type)
VALUES 
('John', 'Smith', 'john.smith@email.com', '+271234567890', 'regular'),
('Emma', 'Johnson', 'emma.j@email.com', '+279876543210', 'student'),
('Mohammed', 'Khan', 'm.khan@email.com', '+277894561230', 'senior');

-- Books
INSERT INTO books (isbn, title, edition, publication_year, publisher_id, category_id, pages, total_copies, available_copies)
VALUES 
('978-0451524935', '1984', '1st', 1949, 1, 2, 328, 5, 3),
('978-0747532743', 'Harry Potter and the Philosopher\'s Stone', '20th Anniversary', 1997, 2, 5, 223, 3, 1),
('978-0062316097', 'Sapiens: A Brief History of Humankind', 'Revised', 2011, 3, 4, 512, 2, 2),
('978-0307743657', '11/22/63', 'Reprint', 2011, 1, 1, 849, 4, 4);

-- Book-Author relationships
INSERT INTO book_authors (book_id, author_id)
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4);

-- Loans
INSERT INTO loans (book_id, member_id, loan_date, due_date, status)
VALUES 
(1, 1, '2025-05-01', '2025-05-15', 'returned'),
(2, 2, '2025-06-10', '2025-06-24', 'active'),
(1, 3, '2025-06-15', '2025-06-29', 'active');

-- Fines
INSERT INTO fines (loan_id, amount, status)
VALUES 
(1, 2.50, 'paid');

-- Reservations
INSERT INTO reservations (book_id, member_id, expiry_date)
VALUES 
(3, 1, DATE_ADD(NOW(), INTERVAL 3 DAY));

-- Create views for common queries

-- Available books view
CREATE VIEW available_books AS
SELECT b.book_id, b.title, b.isbn, b.available_copies, 
       GROUP_CONCAT(CONCAT(a.first_name, ' ', a.last_name) AS authors,
       p.name AS publisher, c.name AS category
FROM books b
JOIN publishers p ON b.publisher_id = p.publisher_id
JOIN categories c ON b.category_id = c.category_id
LEFT JOIN book_authors ba ON b.book_id = ba.book_id
LEFT JOIN authors a ON ba.author_id = a.author_id
WHERE b.available_copies > 0
GROUP BY b.book_id;

-- Active loans view
CREATE VIEW active_loans AS
SELECT l.loan_id, m.first_name, m.last_name, b.title, 
       l.loan_date, l.due_date, DATEDIFF(l.due_date, CURDATE()) AS days_remaining
FROM loans l
JOIN members m ON l.member_id = m.member_id
JOIN books b ON l.book_id = b.book_id
WHERE l.status = 'active';

-- Create stored procedures

-- Procedure to borrow a book
DELIMITER //
CREATE PROCEDURE borrow_book(
    IN p_book_id INT,
    IN p_member_id INT,
    IN p_loan_days INT
)
BEGIN
    DECLARE available_count INT;
    
    -- Check available copies
    SELECT available_copies INTO available_count FROM books WHERE book_id = p_book_id;
    
    IF available_count > 0 THEN
        -- Create loan record
        INSERT INTO loans (book_id, member_id, due_date)
        VALUES (p_book_id, p_member_id, DATE_ADD(CURDATE(), INTERVAL p_loan_days DAY));
        
        -- Update book availability
        UPDATE books 
        SET available_copies = available_copies - 1 
        WHERE book_id = p_book_id;
        
        SELECT 'Book borrowed successfully' AS message;
    ELSE
        SELECT 'No available copies of this book' AS message;
    END IF;
END //
DELIMITER ;

-- Procedure to return a book
DELIMITER //
CREATE PROCEDURE return_book(
    IN p_loan_id INT
)
BEGIN
    DECLARE v_book_id INT;
    DECLARE v_due_date DATE;
    DECLARE days_late INT;
    
    -- Get book ID and due date
    SELECT book_id, due_date INTO v_book_id, v_due_date 
    FROM loans 
    WHERE loan_id = p_loan_id AND status = 'active';
    
    IF v_book_id IS NOT NULL THEN
        -- Calculate days late (if any)
        SET days_late = GREATEST(0, DATEDIFF(CURDATE(), v_due_date));
        
        -- Update loan record
        UPDATE loans
        SET return_date = CURDATE(),
            status = 'returned'
        WHERE loan_id = p_loan_id;
        
        -- Update book availability
        UPDATE books
        SET available_copies = available_copies + 1
        WHERE book_id = v_book_id;
        
        -- Create fine if late
        IF days_late > 0 THEN
            INSERT INTO fines (loan_id, amount)
            VALUES (p_loan_id, days_late * 0.50);
            
            SELECT CONCAT('Book returned. Fine issued: $', (days_late * 0.50)) AS message;
        ELSE
            SELECT 'Book returned on time' AS message;
        END IF;
    ELSE
        SELECT 'No active loan found with this ID' AS message;
    END IF;
END //
DELIMITER ;

-- Create triggers

-- Trigger to update due date when loan is renewed
DELIMITER //
CREATE TRIGGER before_loan_renewal
BEFORE UPDATE ON loans
FOR EACH ROW
BEGIN
    IF NEW.renewed_count > OLD.renewed_count AND NEW.status = 'active' THEN
        SET NEW.due_date = DATE_ADD(OLD.due_date, INTERVAL 14 DAY);
    END IF;
END //
DELIMITER ;

-- Trigger to prevent deleting members with active loans
DELIMITER //
CREATE TRIGGER before_member_delete
BEFORE DELETE ON members
FOR EACH ROW
BEGIN
    DECLARE active_loans INT;
    
    SELECT COUNT(*) INTO active_loans
    FROM loans
    WHERE member_id = OLD.member_id AND status = 'active';
    
    IF active_loans > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete member with active loans';
    END IF;
END //
DELIMITER ;
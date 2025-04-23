-- Library Management System Database
-- Database creation
DROP DATABASE IF EXISTS library_management;
CREATE DATABASE library_management;
USE library_management;

-- Members table
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    membership_date DATE NOT NULL,
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active'
);

-- Authors table
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    bio TEXT,
    nationality VARCHAR(50)
);

-- Publishers table
CREATE TABLE publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address TEXT,
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20)
);

-- Books table
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    publication_year INT,
    edition INT,
    publisher_id INT,
    category VARCHAR(50),
    total_copies INT NOT NULL DEFAULT 1,
    available_copies INT NOT NULL DEFAULT 1,
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id)
);

-- Book-Author relationship (Many-to-Many)
CREATE TABLE book_authors (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE
);

-- Loans table
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    status ENUM('on loan', 'returned', 'overdue') DEFAULT 'on loan',
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- Fines table
CREATE TABLE fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    issue_date DATE NOT NULL,
    payment_date DATE,
    status ENUM('unpaid', 'paid') DEFAULT 'unpaid',
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);

-- Sample data insertion
-- Members
INSERT INTO members (first_name, last_name, email, phone, membership_date, status) VALUES
('John', 'Smith', 'john.smith@email.com', '+27608710101', '2025-01-15', 'active'),
('Emily', 'Johnson', 'emily.j@email.com', '+27608722123', '2025-03-22', 'active'),
('Michael', 'Williams', 'michael.w@email.com', NULL, '2025-05-10', 'inactive');

-- Publishers
INSERT INTO publishers (name, address, contact_email, contact_phone) VALUES
('Penguin Books', '123 Bree Ave, South Africa, ZA', 'info@penguin.com', '+27801234567'),
('HarperCollins', '456 Troy Lane, Gauteng, GP', 'contact@harpercollins.com', '+27809876543');

-- Authors
INSERT INTO authors (name, bio, nationality) VALUES
('J.K. Rowling', 'Author of the Harry Potter series', 'British'),
('George R.R. Martin', 'Author of A Song of Ice and Fire series', 'American'),
('Agatha Christie', 'Renowned mystery novelist', 'British');

-- Books
INSERT INTO books (title, isbn, publication_year, edition, publisher_id, category, total_copies, available_copies) VALUES
('Harry Potter and the Philosopher''s Stone', '9780747532743', 1997, 1, 1, 'Fantasy', 5, 3),
('A Game of Thrones', '9780553103540', 1996, 1, 2, 'Fantasy', 3, 1),
('Murder on the Orient Express', '9780062073501', 1934, 1, 2, 'Mystery', 2, 2);

-- Book-Author relationships
INSERT INTO book_authors (book_id, author_id) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Loans
INSERT INTO loans (book_id, member_id, loan_date, due_date, return_date, status) VALUES
(1, 1, '2025-01-10', '2025-01-31', NULL, 'on loan'),
(2, 2, '2025-01-15', '2025-02-05', NULL, 'on loan'),
(1, 3, '2025-12-01', '2025-12-22', '2025-12-20', 'returned');
CREATE DATABASE IF NOT EXISTS banking_db;
USE banking_db;

DROP VIEW IF EXISTS customer_financial_summary;
DROP VIEW IF EXISTS branch_performance;
DROP VIEW IF EXISTS monthly_transaction_summary;
DROP VIEW IF EXISTS customer_activity_summary;

DROP PROCEDURE IF EXISTS get_customer_details;
DROP PROCEDURE IF EXISTS get_customer_transactions;
DROP PROCEDURE IF EXISTS get_transactions_by_date;
DROP PROCEDURE IF EXISTS transfer_money;

DROP TRIGGER IF EXISTS validate_withdrawal;
DROP TRIGGER IF EXISTS update_account_balance;

DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS branches;
DROP TABLE IF EXISTS account_types;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    created_at DATETIME NOT NULL
);

CREATE TABLE branches (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    ifsc_code VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE account_types (
    account_type_id INT PRIMARY KEY,
    type_name VARCHAR(30) NOT NULL UNIQUE,
    minimum_balance DECIMAL(12,2) NOT NULL
);

CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    branch_id INT NOT NULL,
    account_type_id INT NOT NULL,
    opening_date DATE NOT NULL,
    balance DECIMAL(15,2) NOT NULL,
    status VARCHAR(20) NOT NULL,

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (branch_id)
        REFERENCES branches(branch_id),

    FOREIGN KEY (account_type_id)
        REFERENCES account_types(account_type_id)
);

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_date DATETIME NOT NULL,
    description VARCHAR(255),

    FOREIGN KEY (account_id)
        REFERENCES accounts(account_id)
);

CREATE TABLE loans (
    loan_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    loan_type VARCHAR(30) NOT NULL,
    loan_amount DECIMAL(15,2) NOT NULL,
    outstanding_amount DECIMAL(15,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    start_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

INSERT INTO account_types
(account_type_id, type_name, minimum_balance)
VALUES
(1, 'Savings', 500.00),
(2, 'Current', 10000.00),
(3, 'Salary', 0.00);

INSERT INTO branches
(branch_id, branch_name, city, ifsc_code)
VALUES
(1, 'MG Road Branch', 'Bengaluru', 'BANK000001'),
(2, 'Koramangala Branch', 'Bengaluru', 'BANK000002'),
(3, 'Indiranagar Branch', 'Bengaluru', 'BANK000003'),
(4, 'Kuvempu Nagar Branch', 'Mysuru', 'BANK000004'),
(5, 'Panaji Branch', 'Goa', 'BANK000005');

INSERT INTO customers
(customer_id, first_name, last_name, date_of_birth, phone, email, city, created_at)
VALUES
(101, 'Rahul', 'Sharma', '1999-05-12', '9876543210', 'rahul.sharma@gmail.com', 'Bengaluru', '2025-01-15 10:30:00'),
(102, 'Priya', 'Kumar', '2000-08-21', '9876543211', 'priya.kumar@gmail.com', 'Mysuru', '2025-02-10 11:15:00'),
(103, 'Arjun', 'Rao', '1998-03-17', '9876543212', 'arjun.rao@gmail.com', 'Bengaluru', '2025-02-25 09:45:00'),
(104, 'Sneha', 'Nair', '1997-11-05', '9876543213', 'sneha.nair@gmail.com', 'Goa', '2025-03-08 14:20:00'),
(105, 'Vikram', 'Patel', '1995-06-30', '9876543214', 'vikram.patel@gmail.com', 'Hyderabad', '2025-03-18 12:10:00'),
(106, 'Ananya', 'Reddy', '2001-01-14', '9876543215', 'ananya.reddy@gmail.com', 'Bengaluru', '2025-04-02 10:05:00'),
(107, 'Karan', 'Mehta', '1996-09-22', '9876543216', 'karan.mehta@gmail.com', 'Chennai', '2025-04-20 15:30:00'),
(108, 'Neha', 'Joshi', '1999-12-11', '9876543217', 'neha.joshi@gmail.com', 'Mysuru', '2025-05-05 09:20:00'),
(109, 'Rohit', 'Verma', '1994-04-09', '9876543218', 'rohit.verma@gmail.com', 'Bengaluru', '2025-05-19 13:45:00'),
(110, 'Kavya', 'Iyer', '2000-07-26', '9876543219', 'kavya.iyer@gmail.com', 'Goa', '2025-06-01 11:00:00'),
(111, 'Aditya', 'Desai', '1997-02-18', '9876543220', 'aditya.desai@gmail.com', 'Bengaluru', '2025-06-14 16:10:00'),
(112, 'Meera', 'Menon', '1998-10-03', '9876543221', 'meera.menon@gmail.com', 'Chennai', '2025-07-03 10:40:00'),
(113, 'Sanjay', 'Kulkarni', '1993-05-27', '9876543222', 'sanjay.kulkarni@gmail.com', 'Mysuru', '2025-07-18 12:25:00'),
(114, 'Pooja', 'Singh', '2001-09-15', '9876543223', 'pooja.singh@gmail.com', 'Hyderabad', '2025-08-06 14:50:00'),
(115, 'Manish', 'Gupta', '1992-12-29', '9876543224', 'manish.gupta@gmail.com', 'Bengaluru', '2025-08-22 09:35:00'),
(116, 'Divya', 'Shetty', '1999-03-08', '9876543225', 'divya.shetty@gmail.com', 'Goa', '2025-09-10 15:15:00'),
(117, 'Nikhil', 'Bhat', '1996-07-19', '9876543226', 'nikhil.bhat@gmail.com', 'Bengaluru', '2025-09-25 11:45:00'),
(118, 'Aisha', 'Khan', '2000-11-23', '9876543227', 'aisha.khan@gmail.com', 'Chennai', '2025-10-12 13:30:00'),
(119, 'Suresh', 'Naik', '1991-01-31', '9876543228', 'suresh.naik@gmail.com', 'Mysuru', '2025-11-03 10:15:00'),
(120, 'Sneha', 'Nair', '1998-06-16', '9876543229', 'sneha.nair2@gmail.com', 'Goa', '2025-11-20 16:00:00');

INSERT INTO accounts
(account_id, customer_id, branch_id, account_type_id, opening_date, balance, status)
VALUES
(10001, 101, 1, 1, '2025-01-15', 75000.00, 'ACTIVE'),
(10002, 101, 1, 3, '2025-02-01', 42000.00, 'ACTIVE'),
(10003, 102, 4, 1, '2025-02-10', 58000.00, 'ACTIVE'),
(10004, 103, 2, 1, '2025-02-25', 92000.00, 'ACTIVE'),
(10005, 103, 2, 2, '2025-03-01', 250000.00, 'ACTIVE'),
(10006, 104, 5, 1, '2025-03-08', 45000.00, 'ACTIVE'),
(10007, 105, 1, 2, '2025-03-18', 310000.00, 'ACTIVE'),
(10008, 106, 3, 3, '2025-04-02', 68000.00, 'ACTIVE'),
(10009, 107, 2, 1, '2025-04-20', 39000.00, 'ACTIVE'),
(10010, 108, 4, 1, '2025-05-05', 125000.00, 'ACTIVE'),
(10011, 108, 4, 3, '2025-05-20', 55000.00, 'ACTIVE'),
(10012, 109, 3, 1, '2025-05-19', 87000.00, 'ACTIVE'),
(10013, 110, 5, 1, '2025-06-01', 62000.00, 'ACTIVE'),
(10014, 111, 1, 2, '2025-06-14', 425000.00, 'ACTIVE'),
(10015, 112, 2, 1, '2025-07-03', 73000.00, 'ACTIVE'),
(10016, 112, 2, 3, '2025-07-15', 51000.00, 'ACTIVE'),
(10017, 113, 4, 1, '2025-07-18', 96000.00, 'ACTIVE'),
(10018, 114, 1, 1, '2025-08-06', 48000.00, 'ACTIVE'),
(10019, 115, 3, 2, '2025-08-22', 380000.00, 'ACTIVE'),
(10020, 115, 3, 1, '2025-09-01', 91000.00, 'ACTIVE'),
(10021, 116, 5, 1, '2025-09-10', 57000.00, 'ACTIVE'),
(10022, 117, 1, 3, '2025-09-25', 66000.00, 'ACTIVE'),
(10023, 118, 2, 1, '2025-10-12', 44000.00, 'ACTIVE'),
(10024, 119, 4, 1, '2025-11-03', 115000.00, 'ACTIVE'),
(10025, 120, 5, 1, '2025-11-20', 52000.00, 'ACTIVE'),
(10026, 101, 1, 1, '2026-01-10', 83000.00, 'ACTIVE'),
(10027, 105, 1, 1, '2026-01-20', 72000.00, 'ACTIVE'),
(10028, 109, 3, 3, '2026-02-05', 61000.00, 'ACTIVE'),
(10029, 115, 3, 1, '2026-02-18', 105000.00, 'ACTIVE'),
(10030, 120, 5, 3, '2026-03-02', 69000.00, 'ACTIVE');

INSERT INTO transactions
(transaction_id, account_id, transaction_type, amount, transaction_date, description)
VALUES
(50001, 10001, 'DEPOSIT', 25000.00, '2025-01-20 10:15:00', 'Salary credit'),
(50002, 10001, 'WITHDRAWAL', 5000.00, '2025-01-22 14:30:00', 'ATM withdrawal'),
(50003, 10002, 'DEPOSIT', 18000.00, '2025-02-05 09:45:00', 'Salary credit'),
(50004, 10003, 'DEPOSIT', 30000.00, '2025-02-12 11:20:00', 'Cash deposit'),
(50005, 10004, 'WITHDRAWAL', 7500.00, '2025-02-28 16:10:00', 'Online purchase'),
(50006, 10005, 'DEPOSIT', 50000.00, '2025-03-03 10:00:00', 'Business income'),
(50007, 10006, 'WITHDRAWAL', 4000.00, '2025-03-10 13:25:00', 'ATM withdrawal'),
(50008, 10007, 'DEPOSIT', 65000.00, '2025-03-20 09:30:00', 'Business deposit'),
(50009, 10008, 'DEPOSIT', 22000.00, '2025-04-05 11:10:00', 'Salary credit'),
(50010, 10009, 'WITHDRAWAL', 3500.00, '2025-04-18 15:45:00', 'Utility payment'),
(50011, 10010, 'DEPOSIT', 40000.00, '2025-05-02 10:20:00', 'Salary credit'),
(50012, 10011, 'WITHDRAWAL', 6000.00, '2025-05-15 12:35:00', 'Online shopping'),
(50013, 10012, 'DEPOSIT', 28000.00, '2025-05-25 09:50:00', 'Cash deposit'),
(50014, 10013, 'WITHDRAWAL', 4500.00, '2025-06-07 14:15:00', 'ATM withdrawal'),
(50015, 10014, 'DEPOSIT', 85000.00, '2025-06-18 10:40:00', 'Business income'),
(50016, 10015, 'WITHDRAWAL', 9000.00, '2025-07-05 16:25:00', 'Rent payment'),
(50017, 10016, 'DEPOSIT', 32000.00, '2025-07-12 11:30:00', 'Salary credit'),
(50018, 10017, 'WITHDRAWAL', 5500.00, '2025-07-25 13:45:00', 'ATM withdrawal'),
(50019, 10018, 'DEPOSIT', 20000.00, '2025-08-03 09:15:00', 'Salary credit'),
(50020, 10019, 'WITHDRAWAL', 12000.00, '2025-08-14 15:20:00', 'Business expense'),
(50021, 10020, 'DEPOSIT', 45000.00, '2025-08-28 10:50:00', 'Business income'),
(50022, 10021, 'WITHDRAWAL', 6500.00, '2025-09-06 12:10:00', 'Online purchase'),
(50023, 10022, 'DEPOSIT', 24000.00, '2025-09-15 09:40:00', 'Salary credit'),
(50024, 10023, 'WITHDRAWAL', 3000.00, '2025-09-27 14:55:00', 'Utility payment'),
(50025, 10024, 'DEPOSIT', 38000.00, '2025-10-04 11:25:00', 'Cash deposit'),
(50026, 10025, 'WITHDRAWAL', 7000.00, '2025-10-16 16:00:00', 'ATM withdrawal'),
(50027, 10026, 'DEPOSIT', 30000.00, '2025-10-25 10:35:00', 'Salary credit'),
(50028, 10027, 'WITHDRAWAL', 5000.00, '2025-11-05 13:20:00', 'Online purchase'),
(50029, 10028, 'DEPOSIT', 27000.00, '2025-11-15 09:55:00', 'Salary credit'),
(50030, 10029, 'WITHDRAWAL', 8500.00, '2025-11-28 15:40:00', 'Utility payment'),
(50031, 10030, 'DEPOSIT', 35000.00, '2025-12-03 10:10:00', 'Salary credit'),

(50032, 10001, 'TRANSFER', 8000.00, '2025-12-10 12:30:00', 'Account transfer'),
(50033, 10002, 'WITHDRAWAL', 4500.00, '2025-12-15 14:20:00', 'ATM withdrawal'),
(50034, 10003, 'DEPOSIT', 22000.00, '2025-12-20 09:35:00', 'Cash deposit'),
(50035, 10004, 'TRANSFER', 10000.00, '2026-01-05 11:15:00', 'Account transfer'),
(50036, 10005, 'WITHDRAWAL', 15000.00, '2026-01-08 16:30:00', 'Business expense'),
(50037, 10006, 'DEPOSIT', 28000.00, '2026-01-12 10:45:00', 'Salary credit'),
(50038, 10007, 'TRANSFER', 20000.00, '2026-01-18 13:10:00', 'Account transfer'),
(50039, 10008, 'WITHDRAWAL', 5500.00, '2026-01-22 15:25:00', 'ATM withdrawal'),
(50040, 10009, 'DEPOSIT', 19000.00, '2026-02-02 09:20:00', 'Salary credit'),
(50041, 10010, 'TRANSFER', 12000.00, '2026-02-07 12:40:00', 'Account transfer'),
(50042, 10011, 'DEPOSIT', 25000.00, '2026-02-14 10:30:00', 'Salary credit'),
(50043, 10012, 'WITHDRAWAL', 6000.00, '2026-02-20 14:15:00', 'ATM withdrawal'),
(50044, 10013, 'DEPOSIT', 30000.00, '2026-03-01 09:45:00', 'Salary credit'),
(50045, 10014, 'WITHDRAWAL', 18000.00, '2026-03-06 16:20:00', 'Business expense'),
(50046, 10015, 'TRANSFER', 9000.00, '2026-03-12 11:35:00', 'Account transfer'),
(50047, 10016, 'DEPOSIT', 21000.00, '2026-03-18 10:05:00', 'Salary credit'),
(50048, 10017, 'WITHDRAWAL', 5000.00, '2026-03-24 13:50:00', 'ATM withdrawal'),
(50049, 10018, 'DEPOSIT', 26000.00, '2026-04-02 09:30:00', 'Salary credit'),
(50050, 10019, 'TRANSFER', 25000.00, '2026-04-08 15:10:00', 'Account transfer'),
(50051, 10020, 'WITHDRAWAL', 7500.00, '2026-04-15 12:25:00', 'Utility payment'),
(50052, 10021, 'DEPOSIT', 23000.00, '2026-04-20 10:40:00', 'Salary credit'),
(50053, 10022, 'WITHDRAWAL', 4000.00, '2026-05-03 14:30:00', 'Online purchase'),
(50054, 10023, 'DEPOSIT', 29000.00, '2026-05-09 09:15:00', 'Salary credit'),
(50055, 10024, 'TRANSFER', 15000.00, '2026-05-17 11:50:00', 'Account transfer'),
(50056, 10025, 'WITHDRAWAL', 6500.00, '2026-05-25 16:05:00', 'ATM withdrawal'),
(50057, 10026, 'DEPOSIT', 33000.00, '2026-06-02 10:20:00', 'Salary credit'),
(50058, 10027, 'WITHDRAWAL', 7000.00, '2026-06-08 13:40:00', 'Online purchase'),
(50059, 10028, 'TRANSFER', 11000.00, '2026-06-15 15:25:00', 'Account transfer'),
(50060, 10029, 'DEPOSIT', 36000.00, '2026-06-22 09:50:00', 'Salary credit'),
(50061, 10030, 'WITHDRAWAL', 5000.00, '2026-07-01 14:10:00', 'ATM withdrawal'),

(50062, 10001, 'DEPOSIT', 28000.00, '2026-07-05 10:15:00', 'Salary credit'),
(50063, 10002, 'TRANSFER', 7000.00, '2026-07-10 12:45:00', 'Account transfer'),
(50064, 10003, 'WITHDRAWAL', 4500.00, '2026-07-16 16:20:00', 'ATM withdrawal'),
(50065, 10004, 'DEPOSIT', 31000.00, '2026-07-22 09:35:00', 'Salary credit'),
(50066, 10005, 'TRANSFER', 18000.00, '2026-08-03 11:30:00', 'Account transfer'),
(50067, 10006, 'WITHDRAWAL', 6000.00, '2026-08-09 14:40:00', 'ATM withdrawal'),
(50068, 10007, 'DEPOSIT', 72000.00, '2026-08-15 10:25:00', 'Business income'),
(50069, 10008, 'TRANSFER', 9500.00, '2026-08-21 13:15:00', 'Account transfer'),
(50070, 10009, 'WITHDRAWAL', 3500.00, '2026-08-28 15:50:00', 'Utility payment'),
(50071, 10010, 'DEPOSIT', 42000.00, '2026-09-01 09:45:00', 'Salary credit'),
(50072, 10011, 'WITHDRAWAL', 5500.00, '2026-09-03 12:20:00', 'Online purchase'),
(50073, 10012, 'DEPOSIT', 26000.00, '2026-09-05 10:35:00', 'Cash deposit'),
(50074, 10013, 'TRANSFER', 13000.00, '2026-09-06 14:05:00', 'Account transfer'),
(50075, 10014, 'DEPOSIT', 90000.00, '2026-09-06 10:15:00', 'Business income'),
(50076, 10015, 'WITHDRAWAL', 8000.00, '2026-09-06 16:30:00', 'Rent payment'),
(50077, 10016, 'DEPOSIT', 24000.00, '2026-09-06 11:10:00', 'Salary credit'),
(50078, 10017, 'TRANSFER', 10000.00, '2026-09-06 13:25:00', 'Account transfer'),
(50079, 10018, 'WITHDRAWAL', 4500.00, '2026-09-06 15:40:00', 'ATM withdrawal'),
(50080, 10019, 'DEPOSIT', 50000.00, '2026-09-06 09:55:00', 'Business income');

INSERT INTO loans
(loan_id, customer_id, loan_type, loan_amount, outstanding_amount, interest_rate, start_date, status)
VALUES
(9001, 101, 'HOME', 2500000.00, 2100000.00, 8.50, '2025-06-01', 'ACTIVE'),
(9002, 102, 'PERSONAL', 300000.00, 180000.00, 11.00, '2025-07-15', 'ACTIVE'),
(9003, 103, 'VEHICLE', 800000.00, 520000.00, 9.25, '2025-08-10', 'ACTIVE'),
(9004, 105, 'HOME', 3000000.00, 2650000.00, 8.25, '2025-09-05', 'ACTIVE'),
(9005, 108, 'EDUCATION', 500000.00, 320000.00, 7.50, '2025-10-12', 'ACTIVE'),
(9006, 109, 'PERSONAL', 400000.00, 210000.00, 10.75, '2025-11-20', 'ACTIVE'),
(9007, 111, 'VEHICLE', 1000000.00, 750000.00, 9.00, '2026-01-08', 'ACTIVE'),
(9008, 113, 'HOME', 2000000.00, 1700000.00, 8.40, '2026-02-14', 'ACTIVE'),
(9009, 115, 'BUSINESS', 1500000.00, 1100000.00, 10.25, '2026-03-10', 'ACTIVE'),
(9010, 116, 'EDUCATION', 400000.00, 150000.00, 7.25, '2026-04-05', 'ACTIVE'),
(9011, 118, 'PERSONAL', 250000.00, 100000.00, 11.50, '2026-05-18', 'ACTIVE'),
(9012, 120, 'VEHICLE', 700000.00, 450000.00, 9.50, '2026-06-22', 'ACTIVE');

SELECT
    COUNT(*) AS total_accounts,
    SUM(balance) AS total_bank_balance,
    AVG(balance) AS average_account_balance
FROM accounts;

SELECT
    at.type_name,
    COUNT(a.account_id) AS total_accounts,
    SUM(a.balance) AS total_balance,
    AVG(a.balance) AS average_balance
FROM accounts a
JOIN account_types at
    ON a.account_type_id = at.account_type_id
GROUP BY at.type_name
ORDER BY total_balance DESC;

SELECT
    b.branch_name,
    b.city,
    COUNT(a.account_id) AS total_accounts,
    SUM(a.balance) AS total_balance,
    AVG(a.balance) AS average_balance
FROM accounts a
JOIN branches b
    ON a.branch_id = b.branch_id
GROUP BY b.branch_id, b.branch_name, b.city
ORDER BY total_balance DESC;

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(a.account_id) AS account_count
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(a.account_id) > 1
ORDER BY account_count DESC;

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(a.account_id) AS total_accounts,
    SUM(a.balance) AS total_balance
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_balance DESC
LIMIT 10;

SELECT
    status,
    COUNT(*) AS account_count,
    SUM(balance) AS total_balance
FROM accounts
GROUP BY status
ORDER BY account_count DESC;

SELECT
    transaction_type,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_amount,
    AVG(amount) AS average_amount
FROM transactions
GROUP BY transaction_type
ORDER BY transaction_count DESC;

SELECT
    DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_amount
FROM transactions
GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
ORDER BY transaction_month;

SELECT
    DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,
    transaction_type,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_amount
FROM transactions
GROUP BY
    DATE_FORMAT(transaction_date, '%Y-%m'),
    transaction_type
ORDER BY transaction_month, transaction_type;

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(t.transaction_id) AS transaction_count,
    SUM(t.amount) AS total_transaction_amount,
    AVG(t.amount) AS average_transaction_amount
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
JOIN transactions t
    ON a.account_id = t.account_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY transaction_count DESC;

SELECT
    t.transaction_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    t.transaction_type,
    t.amount,
    t.transaction_date,
    t.description
FROM transactions t
JOIN accounts a
    ON t.account_id = a.account_id
JOIN customers c
    ON a.customer_id = c.customer_id
ORDER BY t.amount DESC
LIMIT 10;

SELECT
    a.account_id,
    a.customer_id,
    COUNT(t.transaction_id) AS transaction_count,
    SUM(t.amount) AS total_transaction_amount
FROM accounts a
JOIN transactions t
    ON a.account_id = t.account_id
GROUP BY a.account_id, a.customer_id
ORDER BY transaction_count DESC
LIMIT 10;

SELECT
    a.account_id,
    a.customer_id,
    a.balance,
    a.status
FROM accounts a
LEFT JOIN transactions t
    ON a.account_id = t.account_id
WHERE t.transaction_id IS NULL;

SELECT
    b.branch_name,
    b.city,
    COUNT(t.transaction_id) AS transaction_count,
    SUM(t.amount) AS total_transaction_amount,
    AVG(t.amount) AS average_transaction_amount
FROM branches b
JOIN accounts a
    ON b.branch_id = a.branch_id
JOIN transactions t
    ON a.account_id = t.account_id
GROUP BY b.branch_id, b.branch_name, b.city
ORDER BY total_transaction_amount DESC;

SELECT
    b.branch_name,
    t.transaction_type,
    COUNT(t.transaction_id) AS transaction_count,
    SUM(t.amount) AS total_amount
FROM branches b
JOIN accounts a
    ON b.branch_id = a.branch_id
JOIN transactions t
    ON a.account_id = t.account_id
GROUP BY b.branch_id, b.branch_name, t.transaction_type
ORDER BY b.branch_name, total_amount DESC;

SELECT
    loan_type,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_loan_amount,
    SUM(outstanding_amount) AS total_outstanding,
    AVG(interest_rate) AS average_interest_rate
FROM loans
GROUP BY loan_type
ORDER BY total_outstanding DESC;

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(l.loan_id) AS total_loans,
    SUM(l.loan_amount) AS total_loan_amount,
    SUM(l.outstanding_amount) AS total_outstanding
FROM customers c
JOIN loans l
    ON c.customer_id = l.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_outstanding DESC;

SELECT
    loan_type,
    SUM(outstanding_amount) AS total_outstanding,
    AVG(outstanding_amount) AS average_outstanding,
    MAX(outstanding_amount) AS highest_outstanding
FROM loans
GROUP BY loan_type
ORDER BY total_outstanding DESC;

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    l.loan_type,
    l.loan_amount,
    l.outstanding_amount
FROM customers c
JOIN loans l
    ON c.customer_id = l.customer_id
WHERE l.loan_amount > 1000000
ORDER BY l.loan_amount DESC;

SELECT
    account_id,
    customer_id,
    balance,
    status
FROM accounts
WHERE balance = (
    SELECT MAX(balance)
    FROM accounts
);

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(a.balance) AS total_balance
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(a.balance) > (
    SELECT AVG(customer_balance)
    FROM (
        SELECT SUM(balance) AS customer_balance
        FROM accounts
        GROUP BY customer_id
    ) AS customer_totals
)
ORDER BY total_balance DESC;

WITH customer_balances AS (
    SELECT
        customer_id,
        SUM(balance) AS total_balance
    FROM accounts
    GROUP BY customer_id
),
customer_activity AS (
    SELECT
        a.customer_id,
        COUNT(t.transaction_id) AS transaction_count
    FROM accounts a
    JOIN transactions t
        ON a.account_id = t.account_id
    GROUP BY a.customer_id
)
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    cb.total_balance,
    COALESCE(ca.transaction_count, 0) AS transaction_count
FROM customers c
JOIN customer_balances cb
    ON c.customer_id = cb.customer_id
LEFT JOIN customer_activity ca
    ON c.customer_id = ca.customer_id
WHERE cb.total_balance > 100000
  AND COALESCE(ca.transaction_count, 0) < 5
ORDER BY cb.total_balance DESC;

WITH customer_balance AS (
    SELECT
        customer_id,
        SUM(balance) AS total_balance
    FROM accounts
    GROUP BY customer_id
),
customer_transactions AS (
    SELECT
        a.customer_id,
        COUNT(t.transaction_id) AS transaction_count,
        SUM(t.amount) AS transaction_amount
    FROM accounts a
    JOIN transactions t
        ON a.account_id = t.account_id
    GROUP BY a.customer_id
),
customer_loans AS (
    SELECT
        customer_id,
        COUNT(loan_id) AS loan_count,
        SUM(outstanding_amount) AS outstanding_amount
    FROM loans
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COALESCE(cb.total_balance, 0) AS total_balance,
    COALESCE(ct.transaction_count, 0) AS transaction_count,
    COALESCE(ct.transaction_amount, 0) AS transaction_amount,
    COALESCE(cl.loan_count, 0) AS loan_count,
    COALESCE(cl.outstanding_amount, 0) AS outstanding_amount
FROM customers c
LEFT JOIN customer_balance cb
    ON c.customer_id = cb.customer_id
LEFT JOIN customer_transactions ct
    ON c.customer_id = ct.customer_id
LEFT JOIN customer_loans cl
    ON c.customer_id = cl.customer_id
ORDER BY total_balance DESC;

WITH customer_balances AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(a.balance) AS total_balance
    FROM customers c
    JOIN accounts a
        ON c.customer_id = a.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT
    customer_id,
    customer_name,
    total_balance,
    RANK() OVER (
        ORDER BY total_balance DESC
    ) AS balance_rank
FROM customer_balances
ORDER BY balance_rank;

WITH customer_balances AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.city,
        SUM(a.balance) AS total_balance
    FROM customers c
    JOIN accounts a
        ON c.customer_id = a.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.city
)
SELECT
    customer_id,
    customer_name,
    city,
    total_balance,
    RANK() OVER (
        PARTITION BY city
        ORDER BY total_balance DESC
    ) AS city_rank
FROM customer_balances
ORDER BY city, city_rank;

WITH monthly_transactions AS (
    SELECT
        DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,
        transaction_type,
        SUM(amount) AS total_amount
    FROM transactions
    GROUP BY
        DATE_FORMAT(transaction_date, '%Y-%m'),
        transaction_type
)
SELECT
    transaction_month,
    transaction_type,
    total_amount,
    RANK() OVER (
        PARTITION BY transaction_month
        ORDER BY total_amount DESC
    ) AS monthly_rank
FROM monthly_transactions
ORDER BY transaction_month, monthly_rank;

SELECT
    transaction_date,
    transaction_type,
    amount,
    SUM(amount) OVER (
        ORDER BY transaction_date, transaction_id
    ) AS running_total
FROM transactions
ORDER BY transaction_date, transaction_id;

CREATE OR REPLACE VIEW customer_financial_summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COALESCE(
        (SELECT SUM(a.balance)
         FROM accounts a
         WHERE a.customer_id = c.customer_id), 0
    ) AS total_balance,
    COALESCE(
        (SELECT COUNT(t.transaction_id)
         FROM accounts a
         JOIN transactions t
             ON a.account_id = t.account_id
         WHERE a.customer_id = c.customer_id), 0
    ) AS total_transactions,
    COALESCE(
        (SELECT COUNT(l.loan_id)
         FROM loans l
         WHERE l.customer_id = c.customer_id), 0
    ) AS total_loans,
    COALESCE(
        (SELECT SUM(l.outstanding_amount)
         FROM loans l
         WHERE l.customer_id = c.customer_id), 0
    ) AS total_loan_outstanding
FROM customers c;

CREATE OR REPLACE VIEW branch_performance AS
SELECT
    b.branch_id,
    b.branch_name,
    b.city,
    COALESCE(a.total_accounts, 0) AS total_accounts,
    COALESCE(a.total_balance, 0) AS total_balance,
    COALESCE(t.total_transactions, 0) AS total_transactions,
    COALESCE(t.total_transaction_amount, 0) AS total_transaction_amount
FROM branches b
LEFT JOIN (
    SELECT
        branch_id,
        COUNT(*) AS total_accounts,
        SUM(balance) AS total_balance
    FROM accounts
    GROUP BY branch_id
) a
    ON b.branch_id = a.branch_id
LEFT JOIN (
    SELECT
        a.branch_id,
        COUNT(t.transaction_id) AS total_transactions,
        SUM(t.amount) AS total_transaction_amount
    FROM accounts a
    JOIN transactions t
        ON a.account_id = t.account_id
    GROUP BY a.branch_id
) t
    ON b.branch_id = t.branch_id;

CREATE OR REPLACE VIEW monthly_transaction_summary AS
SELECT
    DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,
    transaction_type,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_amount,
    AVG(amount) AS average_amount
FROM transactions
GROUP BY
    DATE_FORMAT(transaction_date, '%Y-%m'),
    transaction_type;

CREATE OR REPLACE VIEW customer_activity_summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COALESCE(a.account_count, 0) AS account_count,
    COALESCE(a.total_balance, 0) AS total_balance,
    COALESCE(t.transaction_count, 0) AS transaction_count,
    COALESCE(t.transaction_amount, 0) AS transaction_amount
FROM customers c
LEFT JOIN (
    SELECT
        customer_id,
        COUNT(*) AS account_count,
        SUM(balance) AS total_balance
    FROM accounts
    GROUP BY customer_id
) a
    ON c.customer_id = a.customer_id
LEFT JOIN (
    SELECT
        a.customer_id,
        COUNT(t.transaction_id) AS transaction_count,
        SUM(t.amount) AS transaction_amount
    FROM accounts a
    JOIN transactions t
        ON a.account_id = t.account_id
    GROUP BY a.customer_id
) t
    ON c.customer_id = t.customer_id;

DELIMITER //

CREATE PROCEDURE get_customer_details(IN p_customer_id INT)
BEGIN
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.phone,
        c.email,
        c.city,
        a.account_id,
        a.balance,
        a.status
    FROM customers c
    LEFT JOIN accounts a
        ON c.customer_id = a.customer_id
    WHERE c.customer_id = p_customer_id;
END //

CREATE PROCEDURE get_customer_transactions(IN p_customer_id INT)
BEGIN
    SELECT
        t.transaction_id,
        a.account_id,
        t.transaction_type,
        t.amount,
        t.transaction_date,
        t.description
    FROM accounts a
    JOIN transactions t
        ON a.account_id = t.account_id
    WHERE a.customer_id = p_customer_id
    ORDER BY t.transaction_date DESC;
END //

CREATE PROCEDURE get_transactions_by_date(
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    SELECT
        transaction_id,
        account_id,
        transaction_type,
        amount,
        transaction_date,
        description
    FROM transactions
    WHERE transaction_date >= p_start_date
      AND transaction_date < DATE_ADD(p_end_date, INTERVAL 1 DAY)
    ORDER BY transaction_date;
END //

CREATE PROCEDURE transfer_money(
    IN p_source_account INT,
    IN p_destination_account INT,
    IN p_amount DECIMAL(15,2)
)
BEGIN
    DECLARE v_source_balance DECIMAL(15,2);
    DECLARE v_transaction_id INT;

    START TRANSACTION;

    SELECT balance
    INTO v_source_balance
    FROM accounts
    WHERE account_id = p_source_account
    FOR UPDATE;

    IF p_source_account = p_destination_account THEN

        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Source and destination accounts must be different';

    ELSEIF v_source_balance IS NULL THEN

        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Source account does not exist';

    ELSEIF NOT EXISTS (
        SELECT 1
        FROM accounts
        WHERE account_id = p_destination_account
    ) THEN

        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Destination account does not exist';

    ELSEIF p_amount <= 0 THEN

        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transfer amount must be greater than zero';

    ELSEIF v_source_balance < p_amount THEN

        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient balance';

    ELSE

        SELECT COALESCE(MAX(transaction_id), 50000) + 1
        INTO v_transaction_id
        FROM transactions;

        UPDATE accounts
        SET balance = balance - p_amount
        WHERE account_id = p_source_account;

        UPDATE accounts
        SET balance = balance + p_amount
        WHERE account_id = p_destination_account;

        INSERT INTO transactions
        (
            transaction_id,
            account_id,
            transaction_type,
            amount,
            transaction_date,
            description
        )
        VALUES
        (
            v_transaction_id,
            p_source_account,
            'TRANSFER',
            p_amount,
            NOW(),
            CONCAT('Transfer to account ', p_destination_account)
        );

        INSERT INTO transactions
        (
            transaction_id,
            account_id,
            transaction_type,
            amount,
            transaction_date,
            description
        )
        VALUES
        (
            v_transaction_id + 1,
            p_destination_account,
            'TRANSFER',
            p_amount,
            NOW(),
            CONCAT('Transfer from account ', p_source_account)
        );

        COMMIT;

    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER validate_withdrawal
BEFORE INSERT ON transactions
FOR EACH ROW
BEGIN
    DECLARE v_balance DECIMAL(15,2);

    IF NEW.transaction_type = 'WITHDRAWAL' THEN

        SELECT balance
        INTO v_balance
        FROM accounts
        WHERE account_id = NEW.account_id;

        IF v_balance IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Account does not exist';

        ELSEIF NEW.amount <= 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Withdrawal amount must be greater than zero';

        ELSEIF v_balance < NEW.amount THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Insufficient balance for withdrawal';
        END IF;

    END IF;
END //

CREATE TRIGGER update_account_balance
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN

    IF NEW.transaction_type = 'DEPOSIT' THEN

        UPDATE accounts
        SET balance = balance + NEW.amount
        WHERE account_id = NEW.account_id;

    ELSEIF NEW.transaction_type = 'WITHDRAWAL' THEN

        UPDATE accounts
        SET balance = balance - NEW.amount
        WHERE account_id = NEW.account_id;

    END IF;

END //

DELIMITER ;

SELECT COUNT(*) AS total_customers
FROM customers;

SELECT COUNT(*) AS total_accounts
FROM accounts;

SELECT SUM(balance) AS total_bank_balance
FROM accounts;

SELECT COUNT(*) AS total_transactions
FROM transactions;

SELECT SUM(amount) AS total_transaction_value
FROM transactions;

SELECT COUNT(*) AS total_loans
FROM loans;

SELECT SUM(outstanding_amount) AS total_loan_outstanding
FROM loans;

SELECT *
FROM customer_financial_summary
ORDER BY total_balance DESC;

SELECT *
FROM branch_performance
ORDER BY total_transaction_amount DESC;

SELECT *
FROM monthly_transaction_summary
ORDER BY transaction_month, transaction_type;

SELECT *
FROM customer_activity_summary
ORDER BY transaction_count DESC;

SELECT
    loan_type,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_loan_amount,
    SUM(outstanding_amount) AS total_outstanding
FROM loans
GROUP BY loan_type
ORDER BY total_outstanding DESC;

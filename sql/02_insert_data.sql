-- ============================================================
-- Employee Management System
-- File: 02_insert_data.sql
-- Purpose: Inserts realistic fictional sample data
-- Run this AFTER 01_create_tables.sql
-- ============================================================

-- ------------------------------------------------------------
-- departments (5 rows)
-- ------------------------------------------------------------
INSERT INTO departments (department_id, department_name, location) VALUES
(1, 'Engineering',      'New York'),
(2, 'Sales',             'Chicago'),
(3, 'Marketing',         'Austin'),
(4, 'Human Resources',  'Boston'),
(5, 'Finance',            'Seattle');

-- Keep the sequence in sync since we inserted explicit IDs
SELECT setval('departments_department_id_seq', (SELECT MAX(department_id) FROM departments));

-- ------------------------------------------------------------
-- employees (15 rows)
-- manager_id references another employee_id in this same table
-- ------------------------------------------------------------
INSERT INTO employees (employee_id, first_name, last_name, email, phone, job_title, department_id, manager_id, hire_date, employment_status) VALUES
(1,  'Alex',   'Carter',   'alex.carter@example.com',    '555-0101', 'Engineering Manager',      1, NULL, '2016-03-01', 'Active'),
(2,  'Emma',   'Wilson',   'emma.wilson@example.com',    '555-0102', 'Senior Software Engineer', 1, 1,    '2017-06-15', 'Active'),
(3,  'Daniel', 'Brooks',   'daniel.brooks@example.com',  '555-0103', 'Software Engineer',        1, 1,    '2019-01-10', 'Active'),
(4,  'Sophie', 'Miller',   'sophie.miller@example.com',  '555-0104', 'Sales Manager',            2, NULL, '2015-09-01', 'Active'),
(5,  'James',  'Anderson', 'james.anderson@example.com', '555-0105', 'Sales Executive',          2, 4,    '2018-04-23', 'Active'),
(6,  'Olivia', 'Bennett',  'olivia.bennett@example.com', '555-0106', 'Sales Executive',          2, 4,    '2020-02-11', 'Active'),
(7,  'Noah',   'Parker',   'noah.parker@example.com',    '555-0107', 'Marketing Manager',        3, NULL, '2016-11-05', 'Active'),
(8,  'Grace',  'Thompson', 'grace.thompson@example.com', '555-0108', 'Marketing Specialist',     3, 7,    '2019-07-19', 'Active'),
(9,  'Ethan',  'Collins',  'ethan.collins@example.com',  '555-0109', 'Content Strategist',       3, 7,    '2021-03-08', 'Active'),
(10, 'Mia',    'Davis',    'mia.davis@example.com',      '555-0110', 'HR Manager',               4, NULL, '2014-05-20', 'Active'),
(11, 'Lucas',  'Martin',   'lucas.martin@example.com',   '555-0111', 'HR Specialist',            4, 10,   '2018-10-02', 'Active'),
(12, 'Chloe',  'Adams',    'chloe.adams@example.com',    '555-0112', 'Finance Manager',          5, NULL, '2015-01-15', 'Active'),
(13, 'Ryan',   'Cooper',   'ryan.cooper@example.com',    '555-0113', 'Financial Analyst',        5, 12,   '2019-09-30', 'Active'),
(14, 'Lily',   'Morgan',   'lily.morgan@example.com',    '555-0114', 'Accountant',               5, 12,   '2020-06-17', 'Active'),
(15, 'Henry',  'Walker',   'henry.walker@example.com',   '555-0115', 'Junior Software Engineer', 1, 1,    '2022-08-01', 'Active');

SELECT setval('employees_employee_id_seq', (SELECT MAX(employee_id) FROM employees));

-- ------------------------------------------------------------
-- salaries (20 rows: 15 current + 5 historical raises)
-- ------------------------------------------------------------
INSERT INTO salaries (employee_id, base_salary, bonus, effective_date, is_current) VALUES
-- Current salaries
(1,  125000.00, 8000.00,  '2023-01-01', TRUE),
(2,   92000.00, 4000.00,  '2023-01-01', TRUE),
(3,   72000.00, 2000.00,  '2023-01-01', TRUE),
(4,  118000.00, 10000.00, '2023-01-01', TRUE),
(5,   65000.00, 6000.00,  '2023-01-01', TRUE),
(6,   60000.00, 5000.00,  '2023-01-01', TRUE),
(7,  110000.00, 6000.00,  '2023-01-01', TRUE),
(8,   62000.00, 3000.00,  '2023-01-01', TRUE),
(9,   58000.00, 2000.00,  '2023-01-01', TRUE),
(10, 105000.00, 5000.00,  '2023-01-01', TRUE),
(11,  58000.00, 2000.00,  '2023-01-01', TRUE),
(12, 122000.00, 9000.00,  '2023-01-01', TRUE),
(13,  70000.00, 3000.00,  '2023-01-01', TRUE),
(14,  55000.00, 1500.00,  '2023-01-01', TRUE),
(15,  48000.00, 1000.00,  '2023-01-01', TRUE),
-- Historical (previous) salary records showing a raise over time
(1,  118000.00, 5000.00, '2021-01-01', FALSE),
(2,   85000.00, 3000.00, '2021-01-01', FALSE),
(4,  105000.00, 7000.00, '2020-01-01', FALSE),
(7,  100000.00, 4000.00, '2020-06-01', FALSE),
(10,  98000.00, 4000.00, '2019-01-01', FALSE);

-- ------------------------------------------------------------
-- leave_management (25 rows across all employees)
-- ------------------------------------------------------------
INSERT INTO leave_management (employee_id, leave_type, start_date, end_date, total_days, status, applied_date) VALUES
(1,  'Vacation', '2024-01-10', '2024-01-16', 5, 'Approved', '2023-12-20'),
(1,  'Sick',     '2024-05-02', '2024-05-03', 2, 'Approved', '2024-05-01'),
(2,  'Vacation', '2024-02-05', '2024-02-09', 5, 'Approved', '2024-01-15'),
(2,  'Sick',     '2024-06-11', '2024-06-11', 1, 'Approved', '2024-06-10'),
(3,  'Personal', '2024-03-14', '2024-03-14', 1, 'Pending',  '2024-03-10'),
(3,  'Vacation', '2024-07-01', '2024-07-05', 5, 'Approved', '2024-06-01'),
(4,  'Vacation', '2024-01-22', '2024-01-26', 5, 'Approved', '2023-12-28'),
(4,  'Unpaid',   '2024-04-15', '2024-04-16', 2, 'Rejected', '2024-04-10'),
(5,  'Sick',     '2024-02-19', '2024-02-20', 2, 'Approved', '2024-02-18'),
(5,  'Vacation', '2024-08-05', '2024-08-09', 5, 'Pending',  '2024-07-20'),
(6,  'Personal', '2024-03-01', '2024-03-01', 1, 'Approved', '2024-02-25'),
(6,  'Sick',     '2024-05-20', '2024-05-22', 3, 'Approved', '2024-05-19'),
(7,  'Vacation', '2024-06-10', '2024-06-14', 5, 'Approved', '2024-05-15'),
(7,  'Sick',     '2024-09-02', '2024-09-02', 1, 'Approved', '2024-09-01'),
(8,  'Maternity/Paternity', '2024-01-02', '2024-03-26', 84, 'Approved', '2023-11-01'),
(9,  'Personal', '2024-04-08', '2024-04-08', 1, 'Rejected', '2024-04-05'),
(9,  'Vacation', '2024-07-15', '2024-07-19', 5, 'Approved', '2024-06-20'),
(10, 'Vacation', '2024-02-12', '2024-02-16', 5, 'Approved', '2024-01-20'),
(10, 'Sick',     '2024-05-30', '2024-05-31', 2, 'Approved', '2024-05-29'),
(11, 'Unpaid',   '2024-03-18', '2024-03-20', 3, 'Approved', '2024-03-10'),
(12, 'Vacation', '2024-01-08', '2024-01-12', 5, 'Approved', '2023-12-15'),
(12, 'Sick',     '2024-06-25', '2024-06-25', 1, 'Pending',  '2024-06-24'),
(13, 'Personal', '2024-04-22', '2024-04-22', 1, 'Approved', '2024-04-18'),
(14, 'Sick',     '2024-03-05', '2024-03-06', 2, 'Approved', '2024-03-04'),
(15, 'Vacation', '2024-08-19', '2024-08-21', 3, 'Pending',  '2024-08-01');

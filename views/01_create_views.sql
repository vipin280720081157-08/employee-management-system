-- ============================================================
-- Employee Management System
-- File: 01_create_views.sql
-- Purpose: Creates reusable views on top of the schema
-- Run this AFTER 01_create_tables.sql and 02_insert_data.sql
-- ============================================================

DROP VIEW IF EXISTS employee_leave_summary;
DROP VIEW IF EXISTS department_salary_summary;
DROP VIEW IF EXISTS employee_details_view;

-- ------------------------------------------------------------
-- View 1: employee_details_view
-- A clean, human-readable view of each employee's core details.
-- ------------------------------------------------------------
CREATE VIEW employee_details_view AS
SELECT
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    e.email,
    e.job_title,
    d.department_name,
    e.hire_date
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;

-- ------------------------------------------------------------
-- View 2: department_salary_summary
-- Aggregated salary statistics per department.
-- ------------------------------------------------------------
CREATE VIEW department_salary_summary AS
SELECT
    d.department_name,
    COUNT(e.employee_id)            AS employee_count,
    ROUND(AVG(s.base_salary), 2)    AS average_salary,
    MIN(s.base_salary)              AS minimum_salary,
    MAX(s.base_salary)              AS maximum_salary,
    SUM(s.base_salary + s.bonus)    AS total_salary_expense
FROM departments d
INNER JOIN employees e ON d.department_id = e.department_id
INNER JOIN salaries s ON e.employee_id = s.employee_id
WHERE s.is_current = TRUE
GROUP BY d.department_name;

-- ------------------------------------------------------------
-- View 3: employee_leave_summary
-- Per-employee leave activity, with department context.
-- ------------------------------------------------------------
CREATE VIEW employee_leave_summary AS
SELECT
    e.first_name || ' ' || e.last_name AS employee_name,
    d.department_name,
    COUNT(l.leave_id)                                                       AS total_leave_records,
    COALESCE(SUM(l.total_days), 0)                                          AS total_leave_days,
    COALESCE(SUM(l.total_days) FILTER (WHERE l.status = 'Approved'), 0)     AS approved_leave_days
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
LEFT JOIN leave_management l ON e.employee_id = l.employee_id
GROUP BY e.first_name, e.last_name, d.department_name;


-- ============================================================
-- Example queries using each view
-- ============================================================

-- Example 1: Look up one employee's details
SELECT * FROM employee_details_view
WHERE employee_name = 'Emma Wilson';

-- Example 2: Compare average salary across departments
SELECT * FROM department_salary_summary
ORDER BY average_salary DESC;

-- Example 3: Find employees with the most approved leave days
SELECT * FROM employee_leave_summary
ORDER BY approved_leave_days DESC
LIMIT 5;

-- ============================================================
-- Why views are useful:
-- They save you from retyping the same JOIN/aggregate logic
-- every time, they present a simplified "table-like" interface
-- for reporting, and they let you control what underlying data
-- is exposed without changing the base tables.
-- ============================================================

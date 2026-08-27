-- ============================================================
-- Employee Management System
-- File: 03_queries.sql
-- Purpose: Demonstration queries against the schema and sample data
-- Run this AFTER 01_create_tables.sql and 02_insert_data.sql
-- Queries are organized in numbered sections, roughly easy -> hard
-- ============================================================


-- ============================================================
-- SECTION 1: BASIC SELECTS
-- ============================================================

-- 1. Display all employees
SELECT * FROM employees;

-- 2. Display all departments
SELECT * FROM departments;

-- 3. Display employee details with department names (INNER JOIN)
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    e.job_title,
    d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
ORDER BY e.employee_id;

-- 4. Find employees in a specific department (e.g. Engineering)
SELECT e.first_name, e.last_name, e.job_title
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Engineering';

-- 5. Sort employees by salary (highest first)
SELECT e.first_name, e.last_name, s.base_salary
FROM employees e
INNER JOIN salaries s ON e.employee_id = s.employee_id
WHERE s.is_current = TRUE
ORDER BY s.base_salary DESC;


-- ============================================================
-- SECTION 2: SALARY ANALYSIS
-- ============================================================

-- 6. Find the highest-paid employee(s)
SELECT e.first_name, e.last_name, s.base_salary
FROM employees e
INNER JOIN salaries s ON e.employee_id = s.employee_id
WHERE s.is_current = TRUE
ORDER BY s.base_salary DESC
LIMIT 1;

-- 7. Find the lowest-paid employee(s)
SELECT e.first_name, e.last_name, s.base_salary
FROM employees e
INNER JOIN salaries s ON e.employee_id = s.employee_id
WHERE s.is_current = TRUE
ORDER BY s.base_salary ASC
LIMIT 1;

-- 8. Calculate the average salary across the company
SELECT ROUND(AVG(base_salary), 2) AS company_average_salary
FROM salaries
WHERE is_current = TRUE;

-- 9. Calculate average salary by department
SELECT
    d.department_name,
    ROUND(AVG(s.base_salary), 2) AS average_salary
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN salaries s ON e.employee_id = s.employee_id
WHERE s.is_current = TRUE
GROUP BY d.department_name
ORDER BY average_salary DESC;

-- 10. Calculate total salary expense by department
SELECT
    d.department_name,
    SUM(s.base_salary + s.bonus) AS total_salary_expense
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN salaries s ON e.employee_id = s.employee_id
WHERE s.is_current = TRUE
GROUP BY d.department_name
ORDER BY total_salary_expense DESC;


-- ============================================================
-- SECTION 3: GROUP BY / HAVING
-- ============================================================

-- 11. Count employees per department
SELECT
    d.department_name,
    COUNT(e.employee_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name
ORDER BY employee_count DESC;

-- 12. Find departments with more than 2 employees (HAVING)
SELECT
    d.department_name,
    COUNT(e.employee_id) AS employee_count
FROM departments d
INNER JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING COUNT(e.employee_id) > 2
ORDER BY employee_count DESC;

-- 13. Find employees earning above the company average (subquery)
SELECT
    e.first_name,
    e.last_name,
    s.base_salary
FROM employees e
INNER JOIN salaries s ON e.employee_id = s.employee_id
WHERE s.is_current = TRUE
  AND s.base_salary > (
        SELECT AVG(base_salary) FROM salaries WHERE is_current = TRUE
  )
ORDER BY s.base_salary DESC;

-- 14. Find employees earning above their own department's average salary
SELECT
    e.first_name,
    e.last_name,
    d.department_name,
    s.base_salary
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN salaries s ON e.employee_id = s.employee_id
WHERE s.is_current = TRUE
  AND s.base_salary > (
        SELECT AVG(s2.base_salary)
        FROM employees e2
        INNER JOIN salaries s2 ON e2.employee_id = s2.employee_id
        WHERE e2.department_id = e.department_id
          AND s2.is_current = TRUE
  )
ORDER BY d.department_name, s.base_salary DESC;

-- 15. Analyze salary distribution using CASE (salary bands)
SELECT
    e.first_name,
    e.last_name,
    s.base_salary,
    CASE
        WHEN s.base_salary >= 100000 THEN 'High'
        WHEN s.base_salary >= 65000  THEN 'Medium'
        ELSE 'Entry'
    END AS salary_band
FROM employees e
INNER JOIN salaries s ON e.employee_id = s.employee_id
WHERE s.is_current = TRUE
ORDER BY s.base_salary DESC;


-- ============================================================
-- SECTION 4: LEAVE ANALYSIS
-- ============================================================

-- 16. Display all leave records
SELECT * FROM leave_management ORDER BY start_date;

-- 17. Count leaves taken by each employee
SELECT
    e.first_name,
    e.last_name,
    COUNT(l.leave_id) AS total_leave_requests
FROM employees e
LEFT JOIN leave_management l ON e.employee_id = l.employee_id
GROUP BY e.first_name, e.last_name
ORDER BY total_leave_requests DESC;

-- 18. Count leaves by leave type
SELECT
    leave_type,
    COUNT(*) AS request_count
FROM leave_management
GROUP BY leave_type
ORDER BY request_count DESC;

-- 19. Analyze approved / rejected / pending leave counts
SELECT
    status,
    COUNT(*) AS total_requests,
    SUM(total_days) AS total_days_requested
FROM leave_management
GROUP BY status
ORDER BY total_requests DESC;

-- 20. Find the employee(s) with the most total leave days taken (approved only)
SELECT
    e.first_name,
    e.last_name,
    SUM(l.total_days) AS total_approved_days
FROM employees e
INNER JOIN leave_management l ON e.employee_id = l.employee_id
WHERE l.status = 'Approved'
GROUP BY e.first_name, e.last_name
ORDER BY total_approved_days DESC
LIMIT 3;

-- 21. Calculate total leave days taken across the whole company (approved only)
SELECT SUM(total_days) AS total_approved_leave_days
FROM leave_management
WHERE status = 'Approved';


-- ============================================================
-- SECTION 5: MULTI-TABLE JOINS & DATE OPERATIONS
-- ============================================================

-- 22. Multi-table JOIN: employee + department + current salary + leave count
SELECT
    e.first_name,
    e.last_name,
    d.department_name,
    s.base_salary,
    COUNT(l.leave_id) AS leave_requests
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN salaries s ON e.employee_id = s.employee_id AND s.is_current = TRUE
LEFT JOIN leave_management l ON e.employee_id = l.employee_id
GROUP BY e.first_name, e.last_name, d.department_name, s.base_salary
ORDER BY d.department_name, e.last_name;

-- 23. LEFT JOIN: list every employee even if they have never requested leave
SELECT
    e.first_name,
    e.last_name,
    l.leave_type,
    l.status
FROM employees e
LEFT JOIN leave_management l ON e.employee_id = l.employee_id
ORDER BY e.employee_id;

-- 24. Employees hired more than 5 years ago (date calculation)
SELECT
    first_name,
    last_name,
    hire_date,
    AGE(CURRENT_DATE, hire_date) AS tenure
FROM employees
WHERE hire_date <= CURRENT_DATE - INTERVAL '5 years'
ORDER BY hire_date;

-- 25. Employees who joined in each year (date extraction + GROUP BY)
SELECT
    EXTRACT(YEAR FROM hire_date) AS hire_year,
    COUNT(*) AS employees_hired
FROM employees
GROUP BY hire_year
ORDER BY hire_year;

-- 26. Show each employee alongside their manager's name (self-JOIN)
SELECT
    emp.first_name || ' ' || emp.last_name AS employee_name,
    mgr.first_name || ' ' || mgr.last_name AS manager_name
FROM employees emp
LEFT JOIN employees mgr ON emp.manager_id = mgr.employee_id
ORDER BY manager_name NULLS FIRST;

-- 27. Salary history: show all raises given to employees who have more than one salary record
SELECT
    e.first_name,
    e.last_name,
    s.base_salary,
    s.effective_date,
    s.is_current
FROM employees e
INNER JOIN salaries s ON e.employee_id = s.employee_id
WHERE e.employee_id IN (
    SELECT employee_id FROM salaries GROUP BY employee_id HAVING COUNT(*) > 1
)
ORDER BY e.employee_id, s.effective_date;

-- 28. Aggregate summary per department: headcount, avg salary, total leave days (multi-table)
SELECT
    d.department_name,
    COUNT(DISTINCT e.employee_id) AS headcount,
    ROUND(AVG(s.base_salary), 2) AS avg_salary,
    COALESCE(SUM(l.total_days), 0) AS total_leave_days
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
LEFT JOIN salaries s ON e.employee_id = s.employee_id AND s.is_current = TRUE
LEFT JOIN leave_management l ON e.employee_id = l.employee_id AND l.status = 'Approved'
GROUP BY d.department_name
ORDER BY d.department_name;

-- 29. Employees currently on long leave (more than 7 days, approved)
SELECT
    e.first_name,
    e.last_name,
    l.leave_type,
    l.total_days,
    l.start_date,
    l.end_date
FROM employees e
INNER JOIN leave_management l ON e.employee_id = l.employee_id
WHERE l.status = 'Approved'
  AND l.total_days > 7
ORDER BY l.total_days DESC;

-- 30. Full aggregate + CASE report: department, headcount, avg salary, and a cost tier label
SELECT
    d.department_name,
    COUNT(e.employee_id) AS headcount,
    ROUND(AVG(s.base_salary), 2) AS avg_salary,
    CASE
        WHEN AVG(s.base_salary) >= 100000 THEN 'High Cost'
        WHEN AVG(s.base_salary) >= 65000  THEN 'Medium Cost'
        ELSE 'Low Cost'
    END AS department_cost_tier
FROM departments d
INNER JOIN employees e ON d.department_id = e.department_id
INNER JOIN salaries s ON e.employee_id = s.employee_id AND s.is_current = TRUE
GROUP BY d.department_name
ORDER BY avg_salary DESC;

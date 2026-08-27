-- ============================================================
-- Employee Management System
-- File: 01_create_tables.sql
-- Purpose: Creates the complete database schema
-- Database: employee_management_system
-- ============================================================

DROP TABLE IF EXISTS leave_management CASCADE;
DROP TABLE IF EXISTS salaries CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS departments CASCADE;

-- ------------------------------------------------------------
-- Table: departments
-- Stores each department in the company.
-- ------------------------------------------------------------
CREATE TABLE departments (
    department_id     SERIAL PRIMARY KEY,
    department_name   VARCHAR(100) NOT NULL UNIQUE,
    location           VARCHAR(100) NOT NULL,
    created_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------
-- Table: employees
-- Stores each employee and links them to a department and,
-- optionally, to a manager (who is also an employee).
-- ------------------------------------------------------------
CREATE TABLE employees (
    employee_id        SERIAL PRIMARY KEY,
    first_name          VARCHAR(50)  NOT NULL,
    last_name           VARCHAR(50)  NOT NULL,
    email                VARCHAR(150) NOT NULL UNIQUE,
    phone                VARCHAR(20),
    job_title            VARCHAR(100) NOT NULL,
    department_id       INT NOT NULL,
    manager_id           INT,
    hire_date            DATE NOT NULL,
    employment_status    VARCHAR(20) NOT NULL DEFAULT 'Active',
    created_at           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_employees_department
        FOREIGN KEY (department_id) REFERENCES departments (department_id),

    CONSTRAINT fk_employees_manager
        FOREIGN KEY (manager_id) REFERENCES employees (employee_id),

    CONSTRAINT chk_employment_status
        CHECK (employment_status IN ('Active', 'Inactive', 'Terminated')),

    CONSTRAINT chk_hire_date
        CHECK (hire_date <= CURRENT_DATE)
);

-- ------------------------------------------------------------
-- Table: salaries
-- Stores salary records for employees. An employee can have
-- more than one row here over time (salary history), with
-- is_current marking the active salary record.
-- ------------------------------------------------------------
CREATE TABLE salaries (
    salary_id       SERIAL PRIMARY KEY,
    employee_id      INT NOT NULL,
    base_salary      NUMERIC(10, 2) NOT NULL,
    bonus             NUMERIC(10, 2) NOT NULL DEFAULT 0,
    currency          VARCHAR(10) NOT NULL DEFAULT 'USD',
    effective_date   DATE NOT NULL,
    is_current        BOOLEAN NOT NULL DEFAULT TRUE,
    created_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_salaries_employee
        FOREIGN KEY (employee_id) REFERENCES employees (employee_id)
        ON DELETE CASCADE,

    CONSTRAINT chk_base_salary_positive
        CHECK (base_salary > 0),

    CONSTRAINT chk_bonus_non_negative
        CHECK (bonus >= 0)
);

-- ------------------------------------------------------------
-- Table: leave_management
-- Stores leave requests/records for employees.
-- ------------------------------------------------------------
CREATE TABLE leave_management (
    leave_id        SERIAL PRIMARY KEY,
    employee_id      INT NOT NULL,
    leave_type       VARCHAR(30) NOT NULL,
    start_date       DATE NOT NULL,
    end_date         DATE NOT NULL,
    total_days       INT NOT NULL,
    status            VARCHAR(20) NOT NULL DEFAULT 'Pending',
    applied_date     DATE NOT NULL DEFAULT CURRENT_DATE,

    CONSTRAINT fk_leave_employee
        FOREIGN KEY (employee_id) REFERENCES employees (employee_id)
        ON DELETE CASCADE,

    CONSTRAINT chk_leave_type
        CHECK (leave_type IN ('Sick', 'Vacation', 'Personal', 'Maternity/Paternity', 'Unpaid')),

    CONSTRAINT chk_leave_status
        CHECK (status IN ('Pending', 'Approved', 'Rejected')),

    CONSTRAINT chk_leave_days_positive
        CHECK (total_days > 0),

    CONSTRAINT chk_leave_date_order
        CHECK (end_date >= start_date)
);

-- ------------------------------------------------------------
-- Helpful indexes for common lookups and joins
-- ------------------------------------------------------------
CREATE INDEX idx_employees_department_id ON employees (department_id);
CREATE INDEX idx_employees_manager_id ON employees (manager_id);
CREATE INDEX idx_salaries_employee_id ON salaries (employee_id);
CREATE INDEX idx_leave_employee_id ON leave_management (employee_id);

-- ============================================================
-- Relationships summary:
--   departments (1) ----< employees        (one department has many employees)
--   employees   (1) ----< employees        (self-referencing: manager_id -> employee_id)
--   employees   (1) ----< salaries         (one employee has many salary records)
--   employees   (1) ----< leave_management (one employee has many leave records)
-- ============================================================

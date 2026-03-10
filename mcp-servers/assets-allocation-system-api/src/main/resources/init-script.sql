-- Asset Allocation MCP Server Database Initialization for H2
-- H2-Compatible SQL with PostgreSQL compatibility mode and sequences

-- Enable H2 PostgreSQL compatibility mode features
SET MODE PostgreSQL;
SET REFERENTIAL_INTEGRITY FALSE;

-- Drop tables if they exist (for clean restart)
DROP TABLE IF EXISTS asset_allocations CASCADE;
DROP TABLE IF EXISTS assets CASCADE;
DROP TABLE IF EXISTS asset_categories CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS departments CASCADE;

-- Reset sequences if they exist
DROP SEQUENCE IF EXISTS dept_seq;
DROP SEQUENCE IF EXISTS emp_seq;
DROP SEQUENCE IF EXISTS asset_cat_seq;
DROP SEQUENCE IF EXISTS asset_seq;
DROP SEQUENCE IF EXISTS alloc_seq;

-- Create sequences for PostgreSQL compatibility
CREATE SEQUENCE IF NOT EXISTS dept_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS emp_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS asset_cat_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS asset_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS alloc_seq START WITH 1 INCREMENT BY 1;

-- Create departments table (H2 PostgreSQL compatible)
CREATE TABLE departments (
    id INT DEFAULT NEXTVAL('dept_seq') PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    manager_name VARCHAR(100),
    budget_allocation DECIMAL(12,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Create employees table (H2 PostgreSQL compatible)
CREATE TABLE employees (
    id INT DEFAULT NEXTVAL('emp_seq') PRIMARY KEY,
    employee_id VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    department_id INT,
    position VARCHAR(100),
    hire_date DATE DEFAULT CURRENT_DATE,
    termination_date DATE NULL,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    manager_id INT,
    location VARCHAR(100),
    cost_center VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Create asset_categories table (H2 PostgreSQL compatible)
CREATE TABLE asset_categories (
    id INT DEFAULT NEXTVAL('asset_cat_seq') PRIMARY KEY,
    category_name VARCHAR(50) UNIQUE NOT NULL,
    description VARCHAR(255),
    requires_approval BOOLEAN DEFAULT FALSE,
    max_allocation_per_employee INT DEFAULT 1,
    depreciation_years INT DEFAULT 3,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Create assets table (H2 PostgreSQL compatible)
CREATE TABLE assets (
    id INT DEFAULT NEXTVAL('asset_seq') PRIMARY KEY,
    asset_tag VARCHAR(50) UNIQUE NOT NULL,
    asset_name VARCHAR(100) NOT NULL,
    category_id INT NOT NULL,
    brand VARCHAR(50),
    model VARCHAR(100),
    serial_number VARCHAR(100) UNIQUE,
    purchase_date DATE DEFAULT CURRENT_DATE,
    purchase_cost DECIMAL(10,2) DEFAULT 0.00,
    warranty_expiry DATE,
    status VARCHAR(20) DEFAULT 'AVAILABLE',
    condition_status VARCHAR(20) DEFAULT 'NEW',
    location VARCHAR(100),
    vendor VARCHAR(100),
    specifications VARCHAR(2000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Create asset_allocations table (H2 PostgreSQL compatible)
CREATE TABLE asset_allocations (
    id INT DEFAULT NEXTVAL('alloc_seq') PRIMARY KEY,
    asset_id INT NOT NULL,
    employee_id INT NOT NULL,
    allocated_date DATE DEFAULT CURRENT_DATE,
    expected_return_date DATE,
    actual_return_date DATE NULL,
    allocation_status VARCHAR(20) DEFAULT 'ALLOCATED',
    allocation_reason VARCHAR(255),
    approved_by VARCHAR(100),
    approval_date DATE DEFAULT CURRENT_DATE,
    return_condition VARCHAR(20),
    notes VARCHAR(2000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Add foreign key constraints after tables are created
ALTER TABLE employees ADD CONSTRAINT fk_emp_dept FOREIGN KEY (department_id) REFERENCES departments(id);
ALTER TABLE employees ADD CONSTRAINT fk_emp_mgr FOREIGN KEY (manager_id) REFERENCES employees(id);
ALTER TABLE assets ADD CONSTRAINT fk_asset_category FOREIGN KEY (category_id) REFERENCES asset_categories(id);
ALTER TABLE asset_allocations ADD CONSTRAINT fk_alloc_asset FOREIGN KEY (asset_id) REFERENCES assets(id);
ALTER TABLE asset_allocations ADD CONSTRAINT fk_alloc_emp FOREIGN KEY (employee_id) REFERENCES employees(id);

-- Re-enable referential integrity
SET REFERENTIAL_INTEGRITY TRUE;

-- Insert sample departments
INSERT INTO departments (name, description, manager_name, budget_allocation) VALUES
('Human Resources', 'Employee management and relations', 'Sarah Johnson', 200000.00),
('Engineering', 'Software development and technical operations', 'Michael Chen', 750000.00),
('Marketing', 'Brand promotion and customer engagement', 'Emily Rodriguez', 300000.00),
('Finance', 'Financial planning and accounting', 'David Kim', 250000.00),
('Operations', 'Business operations and logistics', 'Lisa Thompson', 400000.00);

-- Insert sample employees
INSERT INTO employees (employee_id, first_name, last_name, email, phone, department_id, position, hire_date, status, location, cost_center) VALUES
('EMP001', 'John', 'Smith', 'john.smith@company.com', '+1-555-0101', 1, 'Senior Software Engineer', '2024-01-15', 'ACTIVE', 'Building A', 'IT001'),
('EMP002', 'Maria', 'Garcia', 'maria.garcia@company.com', '+1-555-0201', 3, 'Marketing Manager', '2024-02-01', 'ACTIVE', 'Building B', 'MKT001'),
('EMP003', 'Robert', 'Wilson', 'robert.wilson@company.com', '+1-555-0301', 1, 'HR Specialist', '2024-01-20', 'ACTIVE', 'Building C', 'HR001'),
('EMP004', 'Jennifer', 'Brown', 'jennifer.brown@company.com', '+1-555-0401', 4, 'Financial Analyst', '2024-02-15', 'PENDING', 'Building A', 'FIN001'),
('EMP005', 'Alex', 'Davis', 'alex.davis@company.com', '+1-555-0501', 2, 'Junior Developer', '2024-03-01', 'PENDING', 'Building B', 'ENG001');

-- Insert sample asset categories
INSERT INTO asset_categories (category_name, description, max_allocation_per_employee, requires_approval) VALUES
('LAPTOP', 'Corporate Laptops and Portable Computers', 2, FALSE),
('ID_CARD', 'Employee Identification Cards', 1, TRUE),
('MOBILE_PHONE', 'Corporate Mobile Phones and Devices', 1, TRUE),
('MONITOR', 'External Monitors and Displays', 2, FALSE),
('HEADSET', 'Audio Headsets and Communication Devices', 1, FALSE);

-- Insert sample assets
INSERT INTO assets (asset_tag, asset_name, category_id, brand, model, serial_number, purchase_cost, warranty_expiry, status, condition_status, location, vendor, specifications) VALUES
('LAP-001', 'Dell Latitude 7420 Business Laptop', 1, 'Dell', 'Latitude 7420', 'DL7420001', 1200.00, '2027-01-15', 'AVAILABLE', 'NEW', 'IT Storage Room', 'Dell Technologies', 'Intel i7, 16GB RAM, 512GB SSD'),
('LAP-002', 'MacBook Pro 16"', 1, 'Apple', 'MacBook Pro 16"', 'MBP16002', 2400.00, '2027-02-01', 'AVAILABLE', 'NEW', 'IT Storage Room', 'Apple Inc.', 'Apple M3 Pro, 32GB RAM, 1TB SSD'),
('ID-001', 'Employee ID Card - Level 2 Access', 2, 'HID Global', 'ProxCard II', 'HID001', 25.00, '2029-01-01', 'AVAILABLE', 'NEW', 'Security Office', 'HID Global Corp', 'RFID, Photo ID, Building Access'),
('ID-002', 'Employee ID Card - Level 2 Access', 2, 'HID Global', 'ProxCard II', 'HID002', 25.00, '2029-01-01', 'AVAILABLE', 'NEW', 'Security Office', 'HID Global Corp', 'RFID, Photo ID, Building Access'),
('PHN-001', 'iPhone 15 Pro', 3, 'Apple', 'iPhone 15 Pro', 'IPH15001', 999.00, '2026-03-01', 'AVAILABLE', 'NEW', 'IT Storage Room', 'Apple Inc.', '256GB Storage, Corporate Plan');

-- Insert sample asset allocations
INSERT INTO asset_allocations (asset_id, employee_id, allocated_date, allocation_status, allocation_reason, approved_by, approval_date, notes) VALUES
(1, 1, '2024-01-16', 'ALLOCATED', 'New Employee Setup', 'System Admin', '2024-01-16', 'Allocated for Senior Software Engineer onboarding'),
(3, 1, '2024-01-16', 'ALLOCATED', 'New Employee Setup', 'Security Admin', '2024-01-16', 'ID card issued for building access');

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_employees_employee_id ON employees(employee_id);
CREATE INDEX IF NOT EXISTS idx_employees_email ON employees(email);
CREATE INDEX IF NOT EXISTS idx_employees_department ON employees(department_id);
CREATE INDEX IF NOT EXISTS idx_employees_status ON employees(status);
CREATE INDEX IF NOT EXISTS idx_assets_tag ON assets(asset_tag);
CREATE INDEX IF NOT EXISTS idx_assets_category ON assets(category_id);
CREATE INDEX IF NOT EXISTS idx_assets_status ON assets(status);
CREATE INDEX IF NOT EXISTS idx_asset_categories_name ON asset_categories(category_name);
CREATE INDEX IF NOT EXISTS idx_asset_allocations_asset ON asset_allocations(asset_id);
CREATE INDEX IF NOT EXISTS idx_asset_allocations_employee ON asset_allocations(employee_id);
CREATE INDEX IF NOT EXISTS idx_asset_allocations_status ON asset_allocations(allocation_status);

-- Insert completion marker
INSERT INTO departments (name, description) VALUES ('_INIT_COMPLETE_', 'H2 Asset Allocation Database initialization completed successfully');

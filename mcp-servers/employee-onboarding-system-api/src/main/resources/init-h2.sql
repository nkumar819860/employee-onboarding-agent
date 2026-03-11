-- Employee Onboarding MCP Server Database Initialization for H2
-- H2-Compatible SQL with correct syntax and encoding
-- Idempotent script - safe to run multiple times

-- Enable H2 PostgreSQL compatibility mode features
SET MODE PostgreSQL;
SET REFERENTIAL_INTEGRITY FALSE;

-- Create sequences for PostgreSQL compatibility (only if they don't exist)
CREATE SEQUENCE IF NOT EXISTS dept_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS emp_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS doc_seq START WITH 1 INCREMENT BY 1;

-- Create departments table (H2 PostgreSQL compatible)
CREATE TABLE IF NOT EXISTS departments (
    id INT DEFAULT NEXTVAL('dept_seq') PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    manager_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create employees table (H2 PostgreSQL compatible)
CREATE TABLE IF NOT EXISTS employees (
    id INT DEFAULT NEXTVAL('emp_seq') PRIMARY KEY,
    employee_id VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    department_id INT,
    position VARCHAR(100),
    hire_date DATE,
    status VARCHAR(20) DEFAULT 'PENDING',
    salary DECIMAL(10,2),
    manager_id INT,
    address VARCHAR(500),
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create employee_documents table (H2 PostgreSQL compatible)
CREATE TABLE IF NOT EXISTS employee_documents (
    id INT DEFAULT NEXTVAL('doc_seq') PRIMARY KEY,
    employee_id INT,
    document_type VARCHAR(50) NOT NULL,
    document_name VARCHAR(100) NOT NULL,
    document_path VARCHAR(255),
    document_status VARCHAR(20) DEFAULT 'PENDING',
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    verified_at TIMESTAMP NULL,
    verified_by VARCHAR(100)
);

-- Add foreign key constraints after tables are created (H2 compatible approach)
ALTER TABLE employees ADD CONSTRAINT IF NOT EXISTS fk_emp_dept FOREIGN KEY (department_id) REFERENCES departments(id);
ALTER TABLE employees ADD CONSTRAINT IF NOT EXISTS fk_emp_mgr FOREIGN KEY (manager_id) REFERENCES employees(id);
ALTER TABLE employee_documents ADD CONSTRAINT IF NOT EXISTS fk_doc_emp FOREIGN KEY (employee_id) REFERENCES employees(id);

-- Re-enable referential integrity
SET REFERENTIAL_INTEGRITY TRUE;

-- Insert sample departments (only if they don't exist)
MERGE INTO departments (name, description, manager_name) KEY(name) VALUES
('Human Resources', 'Employee management and relations', 'Sarah Johnson'),
('Engineering', 'Software development and technical operations', 'Michael Chen'),
('Marketing', 'Brand promotion and customer engagement', 'Emily Rodriguez'),
('Finance', 'Financial planning and accounting', 'David Kim'),
('Operations', 'Business operations and logistics', 'Lisa Thompson');

-- Insert sample employees (only if they don't exist)
MERGE INTO employees (employee_id, first_name, last_name, email, phone, department_id, position, hire_date, status, salary, address, emergency_contact_name, emergency_contact_phone) KEY(employee_id) VALUES
('EMP001', 'John', 'Smith', 'john.smith@company.com', '+1-555-0101', 2, 'Senior Software Engineer', '2024-01-15', 'ACTIVE', 85000.00, '123 Main St, City, State 12345', 'Jane Smith', '+1-555-0102'),
('EMP002', 'Maria', 'Garcia', 'maria.garcia@company.com', '+1-555-0201', 3, 'Marketing Manager', '2024-02-01', 'ACTIVE', 75000.00, '456 Oak Ave, City, State 12346', 'Carlos Garcia', '+1-555-0202'),
('EMP003', 'Robert', 'Wilson', 'robert.wilson@company.com', '+1-555-0301', 1, 'HR Specialist', '2024-01-20', 'ACTIVE', 60000.00, '789 Pine Rd, City, State 12347', 'Nancy Wilson', '+1-555-0302'),
('EMP004', 'Jennifer', 'Brown', 'jennifer.brown@company.com', '+1-555-0401', 4, 'Financial Analyst', '2024-02-15', 'PENDING', 65000.00, '321 Elm St, City, State 12348', 'Tom Brown', '+1-555-0402'),
('EMP005', 'Alex', 'Davis', 'alex.davis@company.com', '+1-555-0501', 2, 'Junior Developer', '2024-03-01', 'PENDING', 55000.00, '654 Maple Dr, City, State 12349', 'Sam Davis', '+1-555-0502');

-- Insert sample employee documents (only if they don't exist - using composite key)
MERGE INTO employee_documents (employee_id, document_type, document_name, document_status) KEY(employee_id, document_type) VALUES
(1, 'ID_PROOF', 'drivers_license.pdf', 'VERIFIED'),
(1, 'ADDRESS_PROOF', 'utility_bill.pdf', 'VERIFIED'),
(1, 'EDUCATION', 'degree_certificate.pdf', 'VERIFIED'),
(2, 'ID_PROOF', 'passport.pdf', 'VERIFIED'),
(2, 'ADDRESS_PROOF', 'lease_agreement.pdf', 'PENDING'),
(3, 'ID_PROOF', 'drivers_license.pdf', 'VERIFIED'),
(3, 'EDUCATION', 'hr_certification.pdf', 'VERIFIED'),
(4, 'ID_PROOF', 'state_id.pdf', 'PENDING'),
(4, 'EDUCATION', 'mba_certificate.pdf', 'PENDING'),
(5, 'ID_PROOF', 'drivers_license.pdf', 'PENDING');

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_employees_employee_id ON employees(employee_id);
CREATE INDEX IF NOT EXISTS idx_employees_email ON employees(email);
CREATE INDEX IF NOT EXISTS idx_employees_department ON employees(department_id);
CREATE INDEX IF NOT EXISTS idx_employees_status ON employees(status);
CREATE INDEX IF NOT EXISTS idx_employee_documents_employee_id ON employee_documents(employee_id);
CREATE INDEX IF NOT EXISTS idx_employee_documents_type ON employee_documents(document_type);
CREATE INDEX IF NOT EXISTS idx_employee_documents_status ON employee_documents(document_status);

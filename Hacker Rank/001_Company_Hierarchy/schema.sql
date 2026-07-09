CREATE TABLE Company (
    company_code TEXT,
    founder TEXT
);

CREATE TABLE Lead_Manager (
    lead_manager_code TEXT,
    company_code TEXT
);

CREATE TABLE Senior_Manager (
    senior_manager_code TEXT,
    lead_manager_code TEXT,
    company_code TEXT
);

CREATE TABLE Manager (
    manager_code TEXT,
    senior_manager_code TEXT,
    lead_manager_code TEXT,
    company_code TEXT
);

CREATE TABLE Employee (
    employee_code TEXT,
    manager_code TEXT,
    senior_manager_code TEXT,
    lead_manager_code TEXT,
    company_code TEXT
);
-- Organizational Hierarchy Analysis

WITH RECURSIVE t AS (
    -- CEO / top-level manager
    SELECT
        employee_id,
        employee_name,
        manager_id,
        salary,
        1 AS level
    FROM Employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Employees reporting down the hierarchy
    SELECT
        e.employee_id,
        e.employee_name,
        e.manager_id,
        e.salary,
        t.level + 1 AS level
    FROM Employees e
    JOIN t
        ON e.manager_id = t.employee_id
),

emp_hierarchy AS (
    -- Each employee manages themselves for budget calculation
    SELECT
        employee_id AS manager_id,
        employee_id AS employee_id
    FROM Employees

    UNION ALL

    -- Direct and indirect reports
    SELECT
        eh.manager_id,
        e.employee_id
    FROM emp_hierarchy eh
    JOIN Employees e
        ON e.manager_id = eh.employee_id
)

SELECT
    t.employee_id,
    t.employee_name,
    t.level,
    COUNT(eh.employee_id) - 1 AS team_size,
    SUM(emp.salary) AS budget
FROM t
JOIN emp_hierarchy eh
    ON t.employee_id = eh.manager_id
JOIN Employees emp
    ON emp.employee_id = eh.employee_id
GROUP BY
    t.employee_id,
    t.employee_name,
    t.level
ORDER BY
    t.level ASC,
    budget DESC,
    t.employee_name ASC;

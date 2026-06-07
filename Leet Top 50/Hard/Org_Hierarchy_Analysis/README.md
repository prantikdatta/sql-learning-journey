# Organizational Hierarchy Analysis

## Approach

Use recursive CTEs to analyze the employee hierarchy.

### 1. Calculate hierarchy level

The first recursive CTE, `t`, starts from the CEO where `manager_id IS NULL`.

- CEO is assigned `level = 1`.
- Each employee reporting under someone gets `parent level + 1`.

### 2. Build manager-employee hierarchy

The second recursive CTE, `emp_hierarchy`, maps every manager to:

- themself
- all direct reports
- all indirect reports

Including the manager themselves makes budget calculation simpler.

### 3. Calculate team size and budget

For each employee:

- `team_size = COUNT(employee_id) - 1`
  - subtract `1` to exclude the manager themself
- `budget = SUM(salary)`
  - includes the employee's own salary plus all direct and indirect reports

## SQL

```sql
WITH RECURSIVE t AS (
    SELECT
        employee_id,
        employee_name,
        manager_id,
        salary,
        1 AS level
    FROM Employees
    WHERE manager_id IS NULL

    UNION ALL

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
    SELECT
        employee_id AS manager_id,
        employee_id AS employee_id
    FROM Employees

    UNION ALL

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
```

# Employees Whose Manager Left the Company

## Problem

Table: `Employees`

| Column Name | Type    |
|------------|---------|
| employee_id| int     |
| name       | varchar |
| manager_id | int     |
| salary     | int     |

`employee_id` is the primary key.

Find the IDs of employees who:

- have a salary strictly less than `30000`
- have a manager who left the company

A manager has left the company if their `manager_id` does not exist as an `employee_id` in the table.

Return the result ordered by `employee_id`.

## Solution

```sql
SELECT e.employee_id AS employee_id
FROM Employees e
LEFT JOIN Employees e1
    ON e1.employee_id = e.manager_id
WHERE e.salary < 30000
  AND e1.employee_id IS NULL
  AND e.manager_id IS NOT NULL
ORDER BY e.employee_id;
```

## Explanation

The query uses a self `LEFT JOIN`.

- `e` represents each employee.
- `e1` represents that employee's manager.
- If `e1.employee_id IS NULL`, then the manager does not exist in the table.
- `e.manager_id IS NOT NULL` excludes employees who never had a manager.
- `e.salary < 30000` filters only low-salary employees.
- Results are ordered by `employee_id`.

## Complexity Analysis

- Time Complexity: **O(n)**
- Space Complexity: **O(n)**

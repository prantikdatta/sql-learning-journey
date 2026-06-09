# 1731. The Number of Employees Which Report to Each Employee

## Problem

Find all managers, the number of employees who report directly to them, and the average age of their direct reports rounded to the nearest integer.

## Table Structure

| Column Name | Type |
|------------|------|
| employee_id | int |
| name | varchar |
| reports_to | int |
| age | int |

## SQL Solution

```sql
SELECT
    e.employee_id,
    e.name,
    COUNT(e1.employee_id) AS reports_count,
    ROUND(AVG(e1.age)) AS average_age
FROM Employees e
JOIN Employees e1
    ON e.employee_id = e1.reports_to
GROUP BY e.employee_id, e.name
ORDER BY e.employee_id;
```

## Explanation

We use a self join on the `Employees` table.

- `e` represents the manager.
- `e1` represents the employee reporting to that manager.

```sql
ON e.employee_id = e1.reports_to
```

This matches each manager with their direct reports.

Then we count the reporting employees:

```sql
COUNT(e1.employee_id)
```

And calculate their average age:

```sql
ROUND(AVG(e1.age))
```

Finally, we sort the result by `employee_id`.

```sql
ORDER BY e.employee_id
```

## Complexity

- Time Complexity: `O(n)`
- Space Complexity: `O(n)`

# Primary Department for Each Employee

## Problem

Table: `Employee`

| Column Name   | Type    |
|--------------|---------|
| employee_id  | int     |
| department_id| int     |
| primary_flag | varchar |

- `(employee_id, department_id)` is the primary key.
- An employee can belong to multiple departments.
- If an employee belongs to multiple departments, exactly one department is marked with `primary_flag = 'Y'`.
- If an employee belongs to only one department, its `primary_flag` is `'N'`.

Return each employee along with their primary department. For employees who belong to only one department, return their only department.

## Solution

```sql
SELECT employee_id, department_id
FROM Employee
WHERE primary_flag = 'Y'
   OR employee_id IN (
        SELECT employee_id
        FROM Employee
        GROUP BY employee_id
        HAVING COUNT(*) = 1
   );
```

## Explanation

The solution handles two cases:

1. **Employees with multiple departments**
   - Their primary department is explicitly marked with `primary_flag = 'Y'`.
   - We select those rows directly.

2. **Employees with only one department**
   - Their only department has `primary_flag = 'N'`.
   - We identify such employees using:
     ```sql
     GROUP BY employee_id
     HAVING COUNT(*) = 1
     ```
   - Then we include their department in the result.

Combining both conditions returns the required primary department for every employee.

## Complexity Analysis

- Subquery: **O(n)**
- Main query: **O(n)**

Overall complexity: **O(n)**

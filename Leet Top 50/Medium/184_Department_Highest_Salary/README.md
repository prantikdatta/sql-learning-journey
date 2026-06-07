# 184. Department Highest Salary

## Approach

For each employee:

1. Join the `Employee` table with the `Department` table to get the department name.
2. Find the maximum salary within the employee's department using a correlated subquery.
3. Return employees whose salary matches that maximum salary.

This naturally handles ties, so if multiple employees share the highest salary in a department, all of them are returned.

## SQL

```sql
SELECT
    d.name AS Department,
    e.name AS Employee,
    e.salary AS Salary
FROM Employee e
JOIN Department d
    ON e.departmentId = d.id
WHERE e.salary = (
    SELECT MAX(e1.salary)
    FROM Employee e1
    WHERE e1.departmentId = d.id
);
```

## Example

Input:

Employee

| id | name | salary | departmentId |
|----|------|--------|--------------|
| 1 | Joe | 70000 | 1 |
| 2 | Jim | 90000 | 1 |
| 3 | Henry | 80000 | 2 |
| 4 | Sam | 60000 | 2 |
| 5 | Max | 90000 | 1 |

Department

| id | name |
|----|------|
| 1 | IT |
| 2 | Sales |

Output:

| Department | Employee | Salary |
|------------|----------|---------|
| IT | Jim | 90000 |
| IT | Max | 90000 |
| Sales | Henry | 80000 |

Explanation:

- IT department's highest salary is 90000, earned by both Jim and Max.
- Sales department's highest salary is 80000, earned by Henry.

# 185. Department Top Three Salaries

## Approach

A high earner is an employee whose salary is in the **top three unique salaries** within their department.

Use `DENSE_RANK()` because employees with the same salary should receive the same rank.

For each department:

1. Partition employees by `departmentId`.
2. Rank salaries in descending order.
3. Keep only employees whose salary rank is `1`, `2`, or `3`.

## SQL

```sql
WITH t AS (
    SELECT
        d.name AS Department,
        e.name AS Employee,
        e.salary AS Salary,
        DENSE_RANK() OVER (
            PARTITION BY e.departmentId
            ORDER BY e.salary DESC
        ) AS rn
    FROM Employee e
    JOIN Department d
        ON e.departmentId = d.id
)

SELECT
    Department,
    Employee,
    Salary
FROM t
WHERE rn <= 3;
```

## Why `DENSE_RANK()`?

`DENSE_RANK()` handles duplicate salaries correctly.

Example salaries:

| Salary | DENSE_RANK |
|--------|------------|
| 90000 | 1 |
| 85000 | 2 |
| 85000 | 2 |
| 70000 | 3 |

So both employees earning `85000` are included, and the next unique salary still gets rank `3`.

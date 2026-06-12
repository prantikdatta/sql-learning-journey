# 1965. Employees With Missing Information

## Problem

Given two tables:

### Employees

| Column Name | Type |
|------------|------|
| employee_id | int |
| name | varchar |

- `employee_id` is the primary key.
- Each row stores an employee's name.

### Salaries

| Column Name | Type |
|------------|------|
| employee_id | int |
| salary | int |

- `employee_id` is the primary key.
- Each row stores an employee's salary.

## Objective

Find the IDs of employees with missing information.

An employee has missing information if:

- the employee's name is missing, or
- the employee's salary is missing.

Return the result ordered by `employee_id` in ascending order.

---

## Approach

An employee can be missing information in two cases:

1. The employee exists in `Employees` but not in `Salaries`.
2. The employee exists in `Salaries` but not in `Employees`.

We handle both cases separately and combine the results using `UNION`.

---

## SQL Solution

```sql
SELECT e.employee_id
FROM Employees e
LEFT JOIN Salaries s
    ON e.employee_id = s.employee_id
WHERE s.salary IS NULL

UNION

SELECT s.employee_id
FROM Salaries s
LEFT JOIN Employees e
    ON s.employee_id = e.employee_id
WHERE e.employee_id IS NULL

ORDER BY employee_id ASC;
```

---

## Explanation

### Case 1: Salary Is Missing

```sql
SELECT e.employee_id
FROM Employees e
LEFT JOIN Salaries s
    ON e.employee_id = s.employee_id
WHERE s.salary IS NULL
```

This finds employees who have a name but no salary record.

Example:

| employee_id | name | salary |
|------------|------|--------|
| 2 | Crew | NULL |

Employee `2` exists in `Employees`, but not in `Salaries`.

---

### Case 2: Name Is Missing

```sql
SELECT s.employee_id
FROM Salaries s
LEFT JOIN Employees e
    ON s.employee_id = e.employee_id
WHERE e.employee_id IS NULL
```

This finds employees who have a salary but no name record.

Example:

| employee_id | salary | name |
|------------|--------|------|
| 1 | 22517 | NULL |

Employee `1` exists in `Salaries`, but not in `Employees`.

---

### Combine Results

```sql
UNION
```

Combines both sets of missing employee IDs.

`UNION` also removes duplicates automatically, although duplicates are not expected here because `employee_id` is unique in both tables.

---

### Sort Output

```sql
ORDER BY employee_id ASC;
```

Returns the final result in ascending order.

---

## Alternative Solution

```sql
SELECT e.employee_id
FROM (
    SELECT * FROM Employees LEFT JOIN Salaries USING (employee_id)
    UNION
    SELECT * FROM Employees RIGHT JOIN Salaries USING (employee_id)
) e
WHERE e.name IS NULL
   OR e.salary IS NULL
ORDER BY employee_id ASC;
```

This simulates a `FULL OUTER JOIN` in MySQL by combining:

- `LEFT JOIN`
- `RIGHT JOIN`

Then it filters rows where either `name` or `salary` is missing.

---

## Why Not INNER JOIN?

An `INNER JOIN` only returns employees present in both tables.

That would exclude the exact rows we need:

- employees without salary records
- salary records without employee names

So we need outer join logic instead.

---

## Complexity Analysis

Let:

- `E` = number of rows in `Employees`
- `S` = number of rows in `Salaries`

### Time Complexity

```text
O(E + S)
```

assuming indexed joins on `employee_id`.

### Space Complexity

```text
O(E + S)
```

for the union result and sorting.

---

## Key SQL Concepts

- LEFT JOIN
- UNION
- Missing Data Detection
- NULL Filtering
- FULL OUTER JOIN Simulation in MySQL
- ORDER BY

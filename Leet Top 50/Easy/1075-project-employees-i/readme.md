# 1075. Project Employees I

## Problem

Find the average experience years of all employees working on each project.

The average should be rounded to 2 decimal places.

Return the result table in any order.

## Table Structure

### Project

| Column Name | Type |
|------------|------|
| project_id | int |
| employee_id | int |

### Employee

| Column Name | Type |
|------------|------|
| employee_id | int |
| name | varchar |
| experience_years | int |

## SQL Solution

```sql
SELECT
    p.project_id,
    ROUND(AVG(e.experience_years), 2) AS average_years
FROM Project p
JOIN Employee e
    ON p.employee_id = e.employee_id
GROUP BY p.project_id;
```

## Explanation

Each row in the `Project` table tells us which employee is assigned to which project.

We join the `Project` table with the `Employee` table to access each employee's experience.

```sql
JOIN Employee e
    ON p.employee_id = e.employee_id
```

Then, for each project:

```sql
AVG(e.experience_years)
```

calculates the average experience of all employees working on that project.

Finally, round the result to 2 decimal places.

```sql
ROUND(AVG(e.experience_years), 2)
```

Group the records by project:

```sql
GROUP BY p.project_id
```

## Example

Project 1:

| Employee | Experience |
|----------|------------|
| 1 | 3 |
| 2 | 2 |
| 3 | 1 |

Average:

```text
(3 + 2 + 1) / 3 = 2.00
```

Project 2:

| Employee | Experience |
|----------|------------|
| 1 | 3 |
| 4 | 2 |

Average:

```text
(3 + 2) / 2 = 2.50
```

## Complexity

- Time Complexity: `O(n)`
- Space Complexity: `O(1)`

Where:

- `n` = number of rows in the `Project` table

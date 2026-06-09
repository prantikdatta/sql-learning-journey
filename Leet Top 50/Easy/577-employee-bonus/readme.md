# 577. Employee Bonus

## Problem

Report the name and bonus of each employee who:

- has a bonus less than 1000, or
- did not receive a bonus

Return the result table in any order.

## Table Structure

### Employee

| Column Name | Type |
|------------|------|
| empId | int |
| name | varchar |
| supervisor | int |
| salary | int |

### Bonus

| Column Name | Type |
|------------|------|
| empId | int |
| bonus | int |

## SQL Solution

```sql
SELECT
    e.name,
    b.bonus
FROM Employee e
LEFT JOIN Bonus b
    ON e.empId = b.empId
WHERE b.bonus < 1000
   OR b.bonus IS NULL;
```

## Explanation

We use a `LEFT JOIN` to keep all employees, even those who do not have a matching record in the `Bonus` table.

```sql
LEFT JOIN Bonus b
    ON e.empId = b.empId
```

For employees without a bonus record:

```text
bonus = NULL
```

Then filter employees who:

### Have a bonus less than 1000

```sql
b.bonus < 1000
```

### Or did not receive a bonus

```sql
b.bonus IS NULL
```

This returns all employees satisfying either condition.

## Complexity

- Time Complexity: `O(n)`
- Space Complexity: `O(1)`

Where:

- `n` = number of rows processed after the join

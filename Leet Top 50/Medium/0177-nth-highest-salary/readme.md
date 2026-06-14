# 177. Nth Highest Salary

## Problem

Write a SQL function that returns the **Nth highest distinct salary** from the `Employee` table.

If there are fewer than `N` distinct salaries, return `NULL`.

## Table Schema

| Column Name | Type |
| ----------- | ---- |
| id          | int  |
| salary      | int  |

### Primary Key

```text
id
```

## Approach

1. Remove duplicate salaries using `DISTINCT`.
2. Sort salaries in descending order.
3. Use `LIMIT` with an offset of `N - 1` to get the Nth highest salary.
4. If the requested position does not exist, MySQL automatically returns `NULL`.

## SQL Solution

```sql
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
    SET N = N - 1;

    RETURN (
        SELECT DISTINCT salary
        FROM Employee
        ORDER BY salary DESC
        LIMIT N, 1
    );
END
```

## Explanation

### Step 1: Remove Duplicate Salaries

```sql
SELECT DISTINCT salary
FROM Employee
```

Ensures only unique salary values are considered.

### Step 2: Sort Salaries

```sql
ORDER BY salary DESC
```

Orders salaries from highest to lowest.

### Step 3: Get the Nth Salary

```sql
LIMIT N - 1, 1
```

Since MySQL offsets are zero-based:

| N | Offset |
|---|--------|
| 1 | 0 |
| 2 | 1 |
| 3 | 2 |

Therefore, we decrement `N` before using it in `LIMIT`.

### Example

#### Input

| id | salary |
|----|--------|
| 1 | 100 |
| 2 | 200 |
| 3 | 300 |

```sql
SELECT getNthHighestSalary(2);
```

#### Output

| getNthHighestSalary(2) |
|------------------------|
| 200 |

## Complexity Analysis

- Time Complexity: `O(n log n)`
- Space Complexity: `O(n)`

Where:

- `n` = number of rows in the `Employee` table
- Sorting distinct salaries dominates the runtime

# 627. Swap Salary

## Problem

Swap all `'m'` and `'f'` values in the `sex` column using a **single UPDATE statement** without using any temporary tables.

## Table Schema

| Column Name | Type    |
| ----------- | ------- |
| id          | int     |
| name        | varchar |
| sex         | ENUM    |
| salary      | int     |

## Approach

Use a conditional expression inside the `UPDATE` statement:

- If `sex = 'm'`, change it to `'f'`
- Otherwise, change it to `'m'`

Since the column only contains `'m'` and `'f'`, this swaps all values in a single operation.

## SQL Solution

```sql
UPDATE Salary
SET sex = IF(sex = 'm', 'f', 'm');
```

## Explanation

- `IF(condition, true_value, false_value)` evaluates each row.
- Male (`'m'`) values become female (`'f'`).
- Female (`'f'`) values become male (`'m'`).
- The update is performed in one statement without intermediate tables.

## Before

| id | name | sex | salary |
|----|------|-----|--------|
| 1 | A | m | 2500 |
| 2 | B | f | 1500 |
| 3 | C | m | 5500 |
| 4 | D | f | 500 |

## After

| id | name | sex | salary |
|----|------|-----|--------|
| 1 | A | f | 2500 |
| 2 | B | m | 1500 |
| 3 | C | f | 5500 |
| 4 | D | m | 500 |

## Complexity Analysis

- Time Complexity: `O(n)`
- Space Complexity: `O(1)`

Where:

- `n` = number of rows in the `Salary` table

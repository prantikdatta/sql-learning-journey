# 619. Biggest Single Number

## Problem

Given a table `MyNumbers`, find the largest number that appears exactly once.

If no such number exists, return `null`.

## Table Structure

| Column Name | Type |
|------------|------|
| num | int |

## SQL Solution

```sql
SELECT MAX(num) AS num
FROM (
    SELECT num
    FROM MyNumbers
    GROUP BY num
    HAVING COUNT(*) = 1
) t;
```

## Explanation

First, group the rows by `num`.

```sql
GROUP BY num
```

Then keep only numbers that appear once.

```sql
HAVING COUNT(*) = 1
```

After that, find the largest number among those single numbers.

```sql
MAX(num)
```

If there are no single numbers, `MAX()` automatically returns `null`.

## Complexity

- Time Complexity: `O(n)`
- Space Complexity: `O(k)`

Where:

- `n` = total rows in `MyNumbers`
- `k` = number of unique numbers

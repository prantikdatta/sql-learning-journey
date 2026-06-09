# 1633. Percentage of Users Attended a Contest

## Problem

Find the percentage of users registered in each contest.

The result should be:

- rounded to 2 decimal places
- ordered by `percentage` descending
- if tied, ordered by `contest_id` ascending

## Table Structure

### Users

| Column Name | Type |
|------------|------|
| user_id | int |
| user_name | varchar |

### Register

| Column Name | Type |
|------------|------|
| contest_id | int |
| user_id | int |

## SQL Solution

```sql
SELECT
    r.contest_id,
    ROUND(
        COUNT(DISTINCT r.user_id) * 100.0 / (SELECT COUNT(*) FROM Users),
        2
    ) AS percentage
FROM Register r
GROUP BY r.contest_id
ORDER BY percentage DESC, r.contest_id ASC;
```

## Explanation

For each contest, count how many users registered.

```sql
COUNT(DISTINCT r.user_id)
```

Then divide it by the total number of users.

```sql
SELECT COUNT(*) FROM Users
```

Multiply by `100.0` to get the percentage.

```sql
COUNT(DISTINCT r.user_id) * 100.0 / total_users
```

Finally, round the answer to 2 decimal places.

```sql
ROUND(..., 2)
```

The result is sorted by:

```sql
ORDER BY percentage DESC, r.contest_id ASC
```

## Complexity

- Time Complexity: `O(n)`
- Space Complexity: `O(k)`

Where:

- `n` = total rows in `Register`
- `k` = number of unique contests

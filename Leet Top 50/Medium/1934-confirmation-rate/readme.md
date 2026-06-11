````md
# 1934. Confirmation Rate

## Difficulty
Medium

## Problem Statement

The confirmation rate of a user is defined as:

> Number of confirmed messages / Total number of confirmation requests

If a user has never requested a confirmation message, their confirmation rate is `0`.

Return the confirmation rate of each user rounded to two decimal places.

## Tables

### Signups

| Column Name | Type |
|------------|------|
| user_id | int |
| time_stamp | datetime |

- `user_id` is unique.

### Confirmations

| Column Name | Type |
|------------|------|
| user_id | int |
| time_stamp | datetime |
| action | ENUM |

- `(user_id, time_stamp)` is the primary key.
- `action` can be:
  - `'confirmed'`
  - `'timeout'`

## Approach

### Key Observation

For each confirmation request:

- Count it as `1` if the action is `'confirmed'`.
- Count it as `0` if the action is `'timeout'`.

The average of these values directly gives:

```text
confirmed requests / total requests
````

### Steps

1. Start from the `Signups` table to ensure every user appears in the result.
2. Perform a `LEFT JOIN` with `Confirmations`.
3. Convert:

   * `confirmed → 1`
   * `timeout → 0`
4. Calculate the average using `AVG()`.
5. Use `COALESCE()` to return `0` for users with no confirmation requests.
6. Round the result to two decimal places.

## SQL Solution

```sql
SELECT
    s.user_id,
    ROUND(
        COALESCE(
            AVG(
                CASE
                    WHEN c.action = 'confirmed' THEN 1
                    ELSE 0
                END
            ),
            0
        ),
        2
    ) AS confirmation_rate
FROM Signups s
LEFT JOIN Confirmations c
    ON s.user_id = c.user_id
GROUP BY s.user_id;
```

## Example Walkthrough

### User 7

| Action    |
| --------- |
| confirmed |
| confirmed |
| confirmed |

```text
Rate = 3 / 3 = 1.00
```

### User 2

| Action    |
| --------- |
| confirmed |
| timeout   |

```text
Rate = 1 / 2 = 0.50
```

### User 6

No confirmation requests.

```text
Rate = 0.00
```

## Complexity Analysis

| Metric | Complexity |
| ------ | ---------- |
| Time   | O(n)       |
| Space  | O(1)       |

Where `n` is the number of records in the `Confirmations` table.

## Key Concepts

* LEFT JOIN
* CASE Expression
* Aggregate Functions (`AVG`)
* COALESCE
* ROUND

```
```

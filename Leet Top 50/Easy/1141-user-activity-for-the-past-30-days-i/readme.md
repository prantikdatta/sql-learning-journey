# 1141. User Activity for the Past 30 Days I

## Problem

Given the `Activity` table, find the number of daily active users for a 30-day period ending on `2019-07-27`, inclusive.

A user is considered active on a day if they performed at least one activity on that day.

## Table Schema

| Column        | Type |
|---------------|------|
| user_id       | int  |
| session_id    | int  |
| activity_date | date |
| activity_type | enum |

The table may contain duplicate rows.

## Approach

Filter activities within the required 30-day date range.

Then group the rows by `activity_date` and count the number of distinct users active on each day.

## SQL Solution

```sql
SELECT
    activity_date AS day,
    COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27'
GROUP BY activity_date;
```

## Explanation

- The 30-day period ending on `2019-07-27` starts from `2019-06-28`.
- `WHERE` filters only activities within this date range.
- `GROUP BY activity_date` groups activities by day.
- `COUNT(DISTINCT user_id)` counts each active user once per day.
- Days with zero active users are naturally excluded.

## Complexity

- Time Complexity: `O(n)`
- Space Complexity: `O(k)`

Where `n` is the number of rows in the table and `k` is the number of active dates in the filtered range.

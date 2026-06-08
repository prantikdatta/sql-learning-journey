# Find Followers Count

## Problem

Table: `Followers`

| Column Name | Type |
|------------|------|
| user_id | int |
| follower_id | int |

- `(user_id, follower_id)` is the primary key.
- Each row indicates that `follower_id` follows `user_id`.

For each user, return the number of followers they have.

Return the result ordered by `user_id` in ascending order.

## Solution

```sql
SELECT
    user_id,
    COUNT(follower_id) AS followers_count
FROM Followers
GROUP BY user_id
ORDER BY user_id ASC;
```

## Explanation

The query groups rows by `user_id`.

For each user:

- `COUNT(follower_id)` counts how many followers are associated with that user.
- `GROUP BY user_id` aggregates follower counts per user.
- `ORDER BY user_id ASC` sorts the result by user ID in ascending order.

## Complexity Analysis

- Time Complexity: **O(n)**
- Space Complexity: **O(n)**

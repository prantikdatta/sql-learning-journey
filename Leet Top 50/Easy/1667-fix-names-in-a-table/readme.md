# Fix Names in a Table

## Problem

Table: `Users`

| Column Name | Type |
|------------|------|
| user_id | int |
| name | varchar |

- `user_id` is the primary key.
- The `name` column contains only uppercase and lowercase English letters.

Fix each user's name so that:

- The first character is uppercase.
- All remaining characters are lowercase.

Return the result ordered by `user_id`.

## Solution

```sql
SELECT
    user_id,
    CONCAT(
        UPPER(LEFT(name, 1)),
        LOWER(SUBSTRING(name, 2))
    ) AS name
FROM Users
ORDER BY user_id;
```

## Explanation

The query formats each name as follows:

- `LEFT(name, 1)` extracts the first character.
- `UPPER(...)` converts the first character to uppercase.
- `SUBSTRING(name, 2)` extracts the remaining characters.
- `LOWER(...)` converts the remaining characters to lowercase.
- `CONCAT(...)` combines both parts into the correctly formatted name.
- `ORDER BY user_id` sorts the output by user ID.

## Complexity Analysis

- Time Complexity: **O(n × m)**, where `m` is the average length of a name.
- Space Complexity: **O(1)**

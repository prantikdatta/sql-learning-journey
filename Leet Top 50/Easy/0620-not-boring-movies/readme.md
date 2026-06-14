# 620. Not Boring Movies

## Problem

Report all movies that:

- Have an odd-numbered `id`
- Have a `description` other than `"boring"`

Return the result ordered by `rating` in descending order.

## Table Schema

| Column Name | Type    |
| ----------- | ------- |
| id          | int     |
| movie       | varchar |
| description | varchar |
| rating      | float   |

## Approach

1. Filter movies whose `description` is not `"boring"`.
2. Keep only movies with odd-numbered IDs.
3. Sort the remaining movies by `rating` in descending order.

## SQL Solution

```sql
SELECT *
FROM Cinema
WHERE description != 'boring'
  AND MOD(id, 2) = 1
ORDER BY rating DESC;
```

## Explanation

- `description != 'boring'` excludes boring movies.
- `MOD(id, 2) = 1` selects movies with odd IDs.
- `ORDER BY rating DESC` sorts movies from highest to lowest rating.

## Example

### Input

| id | movie      | description | rating |
|----|------------|-------------|--------|
| 1  | War        | great 3D    | 8.9    |
| 2  | Science    | fiction     | 8.5    |
| 3  | irish      | boring      | 6.2    |
| 4  | Ice song   | Fantacy     | 8.6    |
| 5  | House card | Interesting | 9.1    |

### Output

| id | movie      | description | rating |
|----|------------|-------------|--------|
| 5  | House card | Interesting | 9.1    |
| 1  | War        | great 3D    | 8.9    |

## Complexity Analysis

- Time Complexity: `O(n log n)` due to sorting
- Space Complexity: `O(1)`

Where:

- `n` = number of rows in the `Cinema` table

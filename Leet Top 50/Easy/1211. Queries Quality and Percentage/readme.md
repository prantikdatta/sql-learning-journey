# 1211. Queries Quality and Percentage

## Problem

Given a table `Queries`, find:

- `quality`: average of `rating / position`
- `poor_query_percentage`: percentage of queries where `rating < 3`

Both values should be rounded to 2 decimal places.

## Table Structure

| Column Name | Type |
|------------|------|
| query_name | varchar |
| result | varchar |
| position | int |
| rating | int |

## SQL Solution

```sql
SELECT
    query_name,
    ROUND(AVG(rating / position), 2) AS quality,
    ROUND(
        SUM(rating < 3) * 100.0 / COUNT(*),
        2
    ) AS poor_query_percentage
FROM Queries
GROUP BY query_name;

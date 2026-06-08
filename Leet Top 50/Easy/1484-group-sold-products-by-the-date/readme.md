# Group Sold Products By The Date

## Problem

Table: `Activities`

| Column Name | Type    |
|------------|---------|
| sell_date  | date    |
| product    | varchar |

The table may contain duplicate rows.

Find, for each date:

- the number of different products sold
- the names of those products, sorted lexicographically and separated by commas

Return the result ordered by `sell_date`.

## Solution

```sql
SELECT
    sell_date,
    COUNT(DISTINCT product) AS num_sold,
    GROUP_CONCAT(DISTINCT product ORDER BY product) AS products
FROM Activities
GROUP BY sell_date
ORDER BY sell_date;
```

## Explanation

The query groups rows by `sell_date`.

For each date:

- `COUNT(DISTINCT product)` counts unique products sold.
- `GROUP_CONCAT(DISTINCT product ORDER BY product)` combines unique product names into a comma-separated string sorted alphabetically.
- `ORDER BY sell_date` returns the final result in chronological order.

## Complexity Analysis

- Time Complexity: **O(n log n)**
- Space Complexity: **O(n)**

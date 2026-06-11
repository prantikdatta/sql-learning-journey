````md
# 1070. Product Sales Analysis III

## Difficulty
Medium

## Problem Statement

Given a `Sales` table, find all sales entries that occurred in the first year each product was sold.

For every `product_id`, identify the earliest year in which the product appears in the table. Return all rows for that product from that earliest year.

## Table Schema

### Sales

| Column Name | Type | Description |
|------------|------|-------------|
| sale_id | int | Sale ID |
| product_id | int | Product ID |
| year | int | Year of sale |
| quantity | int | Number of units sold |
| price | int | Price per unit |

The primary key is `(sale_id, year)`.

## Required Output

| Column Name | Description |
|------------|-------------|
| product_id | Product ID |
| first_year | The first year the product was sold |
| quantity | Quantity sold in that year |
| price | Price per unit in that year |

## Approach

We need to return every sale record that happened in the first year of each product.

1. Use a subquery to find the minimum `year` for each `product_id`.
2. Join this result back with the `Sales` table.
3. Match both:
   - `product_id`
   - `year = first_year`
4. Return the required columns.

This handles products that may have multiple sales entries in their first year.

## SQL Solution

```sql
SELECT
    s.product_id,
    s.year AS first_year,
    s.quantity,
    s.price
FROM Sales s
JOIN (
    SELECT
        product_id,
        MIN(year) AS first_year
    FROM Sales
    GROUP BY product_id
) f
    ON s.product_id = f.product_id
    AND s.year = f.first_year;
```

## Explanation

For each product, the subquery finds its earliest sale year.

Example:

| product_id | first_year |
|------------|------------|
| 100 | 2008 |
| 200 | 2011 |

Then we join this result with the original `Sales` table to fetch the matching sale rows.

## Complexity Analysis

| Metric | Complexity |
|--------|------------|
| Time | O(n) |
| Space | O(n) |

## Key Concepts

- Subquery
- Aggregate Function `MIN()`
- `GROUP BY`
- Inner Join
- Filtering by earliest year

## LeetCode Link

https://leetcode.com/problems/product-sales-analysis-iii/
````

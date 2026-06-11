# 1070. Product Sales Analysis III

## Problem

Given a `Sales` table, find all sales entries that occurred in the first year each product was sold.

## Table Schema

| Column Name | Type | Description    |
| ----------- | ---- | -------------- |
| sale_id     | int  | Sale ID        |
| product_id  | int  | Product ID     |
| year        | int  | Year of sale   |
| quantity    | int  | Quantity sold  |
| price       | int  | Price per unit |

## Approach

For each product:

* Find the earliest year it was sold using `MIN(year)`.
* Join this result back to the `Sales` table.
* Return all sales records that belong to that first year.

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

## Complexity

* Time Complexity: `O(n)`
* Space Complexity: `O(n)`

## Output

Returns:

* `product_id`
* `first_year`
* `quantity`
* `price`

for all sales that occurred during the first year each product was sold.

# List the Products Ordered in a Period

## Problem

Table: `Products`

| Column Name | Type |
|------------|------|
| product_id | int |
| product_name | varchar |
| product_category | varchar |

Table: `Orders`

| Column Name | Type |
|------------|------|
| product_id | int |
| order_date | date |
| unit | int |

Find the names of products that had at least `100` units ordered in February 2020, along with the total number of units ordered.

Return the result in any order.

## Solution

```sql
SELECT
    p.product_name,
    SUM(o.unit) AS unit
FROM Products p
LEFT JOIN Orders o
    ON p.product_id = o.product_id
WHERE DATE_FORMAT(o.order_date, '%Y-%m') = '2020-02'
GROUP BY p.product_id
HAVING SUM(o.unit) >= 100;
```

## Explanation

The query joins `Products` with `Orders` using `product_id`.

- `DATE_FORMAT(o.order_date, '%Y-%m') = '2020-02'` filters orders from February 2020.
- `GROUP BY p.product_id` groups orders by product.
- `SUM(o.unit)` calculates total units ordered for each product.
- `HAVING SUM(o.unit) >= 100` keeps only products with at least `100` units ordered.

## Complexity Analysis

- Time Complexity: **O(n)**
- Space Complexity: **O(n)**

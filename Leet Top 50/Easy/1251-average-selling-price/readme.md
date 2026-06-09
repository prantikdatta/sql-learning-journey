# 1251. Average Selling Price

## Problem

Find the average selling price for each product.

Formula:

```text
average_price = total revenue / total units sold
```

If a product has no sold units, return `0`.

## Table Structure

### Prices

| Column Name | Type |
|------------|------|
| product_id | int |
| start_date | date |
| end_date | date |
| price | int |

### UnitsSold

| Column Name | Type |
|------------|------|
| product_id | int |
| purchase_date | date |
| units | int |

## SQL Solution

```sql
SELECT
    p.product_id,
    ROUND(
        COALESCE(
            SUM(p.price * u.units) * 1.0 / SUM(u.units),
            0
        ),
        2
    ) AS average_price
FROM Prices p
LEFT JOIN UnitsSold u
    ON p.product_id = u.product_id
   AND u.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY p.product_id;
```

## Explanation

We join `Prices` with `UnitsSold` using:

```sql
p.product_id = u.product_id
```

and match each sale to the correct price period:

```sql
u.purchase_date BETWEEN p.start_date AND p.end_date
```

Then calculate total revenue:

```sql
SUM(p.price * u.units)
```

and total units sold:

```sql
SUM(u.units)
```

Average selling price is:

```sql
SUM(p.price * u.units) / SUM(u.units)
```

We multiply by `1.0` to force decimal division.

```sql
SUM(p.price * u.units) * 1.0 / SUM(u.units)
```

If a product has no sales, the result becomes `NULL`, so we use:

```sql
COALESCE(..., 0)
```

Finally, round to 2 decimal places.

## Complexity

- Time Complexity: `O(n + m)`
- Space Complexity: `O(1)`

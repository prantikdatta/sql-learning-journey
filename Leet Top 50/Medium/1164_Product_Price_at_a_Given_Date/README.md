# 1164. Product Price at a Given Date

## Approach

Each product starts with a default price of `10`.

For every product:

1. Get the latest price change on or before `2019-08-16`.
2. If no such price change exists, use the default price `10`.
3. Use `COALESCE()` to handle products with no valid price update before the target date.

## SQL

```sql
SELECT
    p.product_id,
    COALESCE(
        (
            SELECT p1.new_price
            FROM Products p1
            WHERE p1.product_id = p.product_id
              AND p1.change_date <= '2019-08-16'
            ORDER BY p1.change_date DESC
            LIMIT 1
        ),
        10
    ) AS price
FROM (
    SELECT DISTINCT product_id
    FROM Products
) p;
```

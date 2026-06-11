# 1045. Customers Who Bought All Products

## Problem

Given the `Customer` and `Product` tables, return the IDs of customers who bought all products listed in the `Product` table.

## SQL Pattern

Relational Division using `GROUP BY` and `HAVING`.

## Approach

Group the `Customer` table by `customer_id`.

For each customer, count the number of distinct products they bought:

```sql
COUNT(DISTINCT product_key)
```

Then compare that count with the total number of products:

```sql
SELECT COUNT(*)
FROM Product
```

If both counts are equal, the customer has bought every product.

`DISTINCT` is important because the `Customer` table may contain duplicate rows.

## SQL Solution

```sql
SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (
    SELECT COUNT(*)
    FROM Product
);
```

## Example

### Customer

| customer_id | product_key |
|-------------|-------------|
| 1 | 5 |
| 2 | 6 |
| 3 | 5 |
| 3 | 6 |
| 1 | 6 |

### Product

| product_key |
|-------------|
| 5 |
| 6 |

Customer `1` bought products `5` and `6`.

Customer `2` bought only product `6`.

Customer `3` bought products `5` and `6`.

So the result is:

| customer_id |
|-------------|
| 1 |
| 3 |

## Complexity

- Time Complexity: `O(n)`
- Space Complexity: `O(k)`

Where `n` is the number of rows in `Customer`, and `k` is the number of unique customers.

## Key Takeaways

- Use `COUNT(DISTINCT ...)` when duplicate rows may exist.
- Use `HAVING` to filter grouped results.
- Problems asking for users who completed **all** items often use this pattern.

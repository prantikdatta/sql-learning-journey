# 1084. Sales Analysis III

## Problem

Given the `Product` and `Sales` tables, report all products that were **only sold during the first quarter of 2019**.

The first quarter of 2019 includes all dates from:

```text
2019-01-01 to 2019-03-31
```

inclusive.

A product should be returned only if **every sale of that product** occurred within this date range.

Return the result table in any order.

---

## Schema

### Product

| Column | Type |
|----------|---------|
| product_id | int |
| product_name | varchar |
| unit_price | int |

- `product_id` is the primary key.

### Sales

| Column | Type |
|----------|---------|
| seller_id | int |
| product_id | int |
| buyer_id | int |
| sale_date | date |
| quantity | int |
| price | int |

- `product_id` is a foreign key referencing `Product`.

---

## Solution

```sql
SELECT
    p.product_id,
    p.product_name
FROM Sales s
JOIN Product p
    ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name
HAVING MIN(s.sale_date) >= '2019-01-01'
   AND MAX(s.sale_date) <= '2019-03-31';
```

---

## Approach

For each product:

1. Find the earliest sale date.
2. Find the latest sale date.
3. Keep only products whose entire sale history falls inside Q1 2019.

### Key Observation

If:

```sql
MIN(sale_date) >= '2019-01-01'
```

then the product was never sold before Q1 2019.

And if:

```sql
MAX(sale_date) <= '2019-03-31'
```

then the product was never sold after Q1 2019.

If both conditions are true, every sale occurred during Q1 2019.

---

## Example Walkthrough

### Product 1 (S8)

Sales:

```text
2019-01-21
```

Earliest sale:

```text
2019-01-21
```

Latest sale:

```text
2019-01-21
```

Both dates fall inside Q1 2019.

✅ Included

---

### Product 2 (G4)

Sales:

```text
2019-02-17
2019-06-02
```

Latest sale:

```text
2019-06-02
```

This is after March 31.

❌ Excluded

---

### Product 3 (iPhone)

Sales:

```text
2019-05-13
```

Earliest sale:

```text
2019-05-13
```

This is outside Q1.

❌ Excluded

---

## Alternative Solution

Using conditional aggregation:

```sql
SELECT
    p.product_id,
    p.product_name
FROM Product p
JOIN Sales s
    ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(
    CASE
        WHEN s.sale_date NOT BETWEEN '2019-01-01' AND '2019-03-31'
        THEN 1
        ELSE 0
    END
) = 0;
```

This explicitly checks that no sales occurred outside Q1 2019.

---

## Complexity Analysis

Let:

- `P` = number of products
- `S` = number of sales records

### Time Complexity

```text
O(S)
```

Each sales record is processed once during aggregation.

### Space Complexity

```text
O(P)
```

For maintaining grouped product information.

---

## SQL Concepts Used

- `JOIN`
- `GROUP BY`
- `MIN()`
- `MAX()`
- `HAVING`
- Date filtering
- Aggregate conditions

---

## Key Takeaway

A product is sold **only in Q1 2019** if:

```sql
MIN(sale_date) >= '2019-01-01'
AND
MAX(sale_date) <= '2019-03-31'
```

This concise aggregate-based approach avoids subqueries and efficiently validates the entire sales history of each product.

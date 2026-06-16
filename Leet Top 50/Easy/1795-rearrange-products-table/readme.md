# 1795. Rearrange Products Table

## Problem

Given a `Products` table where each row stores the price of a product in three stores, rearrange the table so that each output row contains:

- `product_id`
- `store`
- `price`

If a product is not available in a store, its price is `NULL`, and that row should not appear in the result.

## Table Schema

```sql
Products(
    product_id INT PRIMARY KEY,
    store1 INT,
    store2 INT,
    store3 INT
)

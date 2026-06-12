# 1581. Customer Who Visited but Did Not Make Any Transactions

## Problem

Given two tables:

### Visits

| Column Name | Type |
|---|---|
| visit_id | int |
| customer_id | int |

`visit_id` is the primary key for this table.

### Transactions

| Column Name | Type |
|---|---|
| transaction_id | int |
| visit_id | int |
| amount | int |

`transaction_id` is the primary key for this table.

Write a SQL query to find customers who visited the mall without making any transactions, and count how many such visits each customer made.

## Approach

We need to identify visits that do not have any matching transaction.

To do that:

1. Start from the `Visits` table.
2. Use a `LEFT JOIN` with the `Transactions` table on `visit_id`.
3. Keep only rows where no transaction exists.
4. Group by `customer_id`.
5. Count the number of visits without transactions.

## SQL Solution

```sql
SELECT 
    v.customer_id,
    COUNT(*) AS count_no_trans
FROM Visits v
LEFT JOIN Transactions t
    ON v.visit_id = t.visit_id
WHERE t.transaction_id IS NULL
GROUP BY v.customer_id;

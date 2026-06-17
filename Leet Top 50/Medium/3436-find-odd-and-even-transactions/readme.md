# 3436. Find Odd and Even Transactions

## Problem

Given a `Transactions` table containing transaction amounts and dates, calculate the total amount of:

- Odd-valued transactions
- Even-valued transactions

for each transaction date.

If a date has no odd or even transactions, return `0` for that category.

Return the result ordered by `transaction_date` in ascending order.

---

## Approach

For every date:

1. Group rows by `transaction_date`.
2. Use conditional aggregation:
   - Add the amount to `odd_sum` when the amount is odd.
   - Add the amount to `even_sum` when the amount is even.
3. Return the dates in ascending order.

Since the `CASE` expression returns `0` when the condition is not satisfied, dates without odd or even transactions automatically produce `0`.

---

## SQL Solution

```sql
SELECT
    transaction_date,
    SUM(
        CASE
            WHEN amount % 2 = 1 THEN amount
            ELSE 0
        END
    ) AS odd_sum,
    SUM(
        CASE
            WHEN amount % 2 = 0 THEN amount
            ELSE 0
        END
    ) AS even_sum
FROM Transactions
GROUP BY transaction_date
ORDER BY transaction_date;
```

---

## Example

### Input

| transaction_id | amount | transaction_date |
|----------------|--------|------------------|
| 1 | 150 | 2024-07-01 |
| 2 | 200 | 2024-07-01 |
| 3 | 75 | 2024-07-01 |
| 4 | 300 | 2024-07-02 |
| 5 | 50 | 2024-07-02 |
| 6 | 120 | 2024-07-03 |

### Output

| transaction_date | odd_sum | even_sum |
|-----------------|---------:|----------:|
| 2024-07-01 | 75 | 350 |
| 2024-07-02 | 0 | 350 |
| 2024-07-03 | 0 | 120 |

---

## Complexity Analysis

- **Time Complexity:** `O(n)`
- **Space Complexity:** `O(1)`

where `n` is the number of rows in the `Transactions` table.

---

## Key Concept

This problem is a classic example of **conditional aggregation**, where `CASE` expressions inside aggregate functions are used to compute multiple grouped statistics in a single query.

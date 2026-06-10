# 1321. Restaurant Growth

## Problem

The `Customer` table contains restaurant customer transactions.

Each row contains:

- `customer_id`
- `name`
- `visited_on`
- `amount`

A customer can visit on a date, and multiple customers can visit on the same date.

The task is to calculate the **7-day moving total** and **7-day moving average** of the restaurant revenue.

For each valid date, return:

- `visited_on`
- `amount` → total revenue in the current 7-day window
- `average_amount` → average revenue over the 7-day window, rounded to 2 decimal places

The result should be ordered by `visited_on` in ascending order.

---

## Approach

### Step 1: Aggregate revenue by date

Since multiple customers can visit on the same date, first calculate total revenue per day.

```sql
SELECT
    visited_on,
    SUM(amount) AS amount
FROM Customer
GROUP BY visited_on
```

This gives one row per `visited_on`.

---

### Step 2: Calculate 7-day moving total

Use a window function with the current row and previous 6 rows.

```sql
SUM(amount) OVER (
    ORDER BY visited_on
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
)
```

This gives the total revenue for the 7-day window.

---

### Step 3: Calculate 7-day moving average

Use `AVG()` on the daily revenue over the same 7-day window.

```sql
AVG(amount) OVER (
    ORDER BY visited_on
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
)
```

Round the result to 2 decimal places.

---

### Step 4: Remove incomplete windows

The first 6 rows do not have a complete 7-day window.

Use `ROW_NUMBER()` and keep only rows where:

```sql
rn >= 7
```

---

## Solution

```sql
WITH daily AS (
    SELECT
        visited_on,
        SUM(amount) AS amount
    FROM Customer
    GROUP BY visited_on
),
calc AS (
    SELECT
        visited_on,
        SUM(amount) OVER (
            ORDER BY visited_on
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS amount,
        ROUND(
            AVG(amount) OVER (
                ORDER BY visited_on
                ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
            ),
            2
        ) AS average_amount,
        ROW_NUMBER() OVER (ORDER BY visited_on) AS rn
    FROM daily
)

SELECT
    visited_on,
    amount,
    average_amount
FROM calc
WHERE rn >= 7;
```

---

## Complexity Analysis

### Time Complexity

```text
O(N log N)
```

The data is grouped by date and ordered by `visited_on` for the window calculation.

### Space Complexity

```text
O(D)
```

where `D` is the number of distinct visit dates.

---

## Key SQL Concepts Used

- Common Table Expression
- Daily Aggregation
- Window Function
- Moving Sum
- Moving Average
- `ROWS BETWEEN 6 PRECEDING AND CURRENT ROW`
- `ROW_NUMBER`
- `ROUND`

# 1174. Immediate Food Delivery II

## Problem

A food delivery company stores customer orders in the `Delivery` table.

An order is considered:

- **Immediate** → `order_date = customer_pref_delivery_date`
- **Scheduled** → `order_date != customer_pref_delivery_date`

The **first order** of a customer is the order with the earliest `order_date`.

Find the percentage of customers whose **first order** was an **immediate order**, rounded to 2 decimal places.

---

## Approach

### Step 1: Find each customer's first order

Using a Common Table Expression (CTE), retrieve rows where the `order_date` matches the minimum order date for each customer.

```sql
WITH fo AS (
    SELECT *
    FROM Delivery
    WHERE (customer_id, order_date) IN (
        SELECT
            customer_id,
            MIN(order_date)
        FROM Delivery
        GROUP BY customer_id
    )
)
```

### Step 2: Identify immediate orders

An order is immediate when:

```sql
order_date = customer_pref_delivery_date
```

Convert the condition into:

- `1` → Immediate
- `0` → Scheduled

using a `CASE` statement.

### Step 3: Calculate percentage

Since `AVG()` computes the average of 1s and 0s:

```sql
AVG(CASE WHEN ... THEN 1 ELSE 0 END)
```

gives the proportion of immediate orders.

Multiply by `100` and round to `2` decimal places.

---

## Solution

```sql
WITH fo AS (
    SELECT *
    FROM Delivery
    WHERE (customer_id, order_date) IN (
        SELECT
            customer_id,
            MIN(order_date)
        FROM Delivery
        GROUP BY customer_id
    )
)

SELECT
    ROUND(
        AVG(
            CASE
                WHEN order_date = customer_pref_delivery_date THEN 1
                ELSE 0
            END
        ) * 100,
        2
    ) AS immediate_percentage
FROM fo;
```

---

## Complexity Analysis

### Time Complexity

- Finding first order per customer: **O(N)**
- Calculating percentage: **O(N)**

Overall:

```text
O(N)
```

### Space Complexity

```text
O(C)
```

where `C` is the number of unique customers.

---

## Key SQL Concepts Used

- Common Table Expressions (CTE)
- Aggregate Functions (`MIN`, `AVG`)
- Conditional Aggregation (`CASE WHEN`)
- Tuple Comparison
- Rounding (`ROUND`)

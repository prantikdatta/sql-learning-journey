# 586. Customer Placing the Largest Number of Orders

## Problem

Given the following table:

### Orders

| Column Name | Type |
|------------|------|
| order_number | int |
| customer_number | int |

- `order_number` is the primary key.
- Each row represents one order placed by a customer.

## Objective

Find the `customer_number` of the customer who placed the largest number of orders.

The original problem guarantees that exactly one customer has placed more orders than every other customer.

### Follow-up

If more than one customer has the largest number of orders, return all such customers.

---

## Approach

Each row in the `Orders` table represents one order.

To find the customer with the most orders:

1. Group rows by `customer_number`.
2. Count the number of orders for each customer.
3. Find the maximum order count.
4. Return customers whose order count equals that maximum.

This solution also handles the follow-up case where multiple customers tie for the maximum number of orders.

---

## SQL Solution

```sql
SELECT customer_number
FROM Orders
GROUP BY customer_number
HAVING COUNT(*) = (
    SELECT MAX(order_count)
    FROM (
        SELECT COUNT(*) AS order_count
        FROM Orders
        GROUP BY customer_number
    ) t
);
```

---

## Explanation

### Step 1: Count Orders Per Customer

```sql
SELECT COUNT(*) AS order_count
FROM Orders
GROUP BY customer_number
```

This produces the number of orders placed by each customer.

Example:

| customer_number | order_count |
|-----------------|-------------|
| 1 | 1 |
| 2 | 1 |
| 3 | 2 |

---

### Step 2: Find the Maximum Order Count

```sql
SELECT MAX(order_count)
FROM (
    SELECT COUNT(*) AS order_count
    FROM Orders
    GROUP BY customer_number
) t
```

From the grouped counts, this finds the largest order count.

For the example:

```text
MAX(order_count) = 2
```

---

### Step 3: Return Customer(s) With That Count

```sql
HAVING COUNT(*) = (...)
```

Filters grouped customers and keeps only those whose total order count equals the maximum.

---

## Simpler Solution for Original Problem Only

Because the original problem guarantees only one top customer, this also works:

```sql
SELECT customer_number
FROM Orders
GROUP BY customer_number
ORDER BY COUNT(*) DESC
LIMIT 1;
```

However, this version returns only one customer and does not handle ties.

---

## Follow-up Tie-Safe Solution

The main solution is tie-safe:

```sql
SELECT customer_number
FROM Orders
GROUP BY customer_number
HAVING COUNT(*) = (
    SELECT MAX(order_count)
    FROM (
        SELECT COUNT(*) AS order_count
        FROM Orders
        GROUP BY customer_number
    ) t
);
```

If two or more customers share the maximum number of orders, all of them are returned.

---

## Example

### Input

| order_number | customer_number |
|--------------|-----------------|
| 1 | 1 |
| 2 | 2 |
| 3 | 3 |
| 4 | 3 |

### Order Counts

| customer_number | orders |
|-----------------|--------|
| 1 | 1 |
| 2 | 1 |
| 3 | 2 |

### Output

| customer_number |
|-----------------|
| 3 |

---

## Complexity Analysis

Let:

- `n` = number of rows in `Orders`
- `k` = number of unique customers

### Time Complexity

```text
O(n)
```

for grouping and counting orders.

### Space Complexity

```text
O(k)
```

for storing grouped customer counts.

---

## Key SQL Concepts

- GROUP BY
- COUNT()
- HAVING
- Subqueries
- MAX()
- Handling Ties

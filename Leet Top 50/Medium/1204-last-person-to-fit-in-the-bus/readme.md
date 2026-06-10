# 1204. Last Person to Fit in the Bus

## Problem

A queue of people is waiting to board a bus.

Each person has:

- `person_id`
- `person_name`
- `weight`
- `turn`

The bus has a maximum weight limit of **1000 kg**.

People board the bus one by one according to their `turn`.

Find the `person_name` of the **last person who can board the bus** without the total weight exceeding `1000 kg`.

---

## Approach

### Step 1: Calculate running total weight

Use a window function to calculate the cumulative weight of people boarding the bus in turn order.

```sql
SUM(weight) OVER (ORDER BY turn)
```

This gives the total bus weight after each person boards.

---

### Step 2: Keep only valid boardings

Filter rows where the cumulative weight is less than or equal to `1000`.

```sql
WHERE total_weight <= 1000
```

---

### Step 3: Find the last valid person

Among all valid rows, the last person is the one with the highest cumulative weight.

```sql
ORDER BY total_weight DESC
LIMIT 1
```

---

## Solution

```sql
WITH turn AS (
    SELECT
        turn,
        person_name,
        SUM(weight) OVER (ORDER BY turn) AS total_weight
    FROM Queue
)

SELECT
    person_name
FROM turn
WHERE total_weight <= 1000
ORDER BY total_weight DESC
LIMIT 1;
```

---

## Complexity Analysis

### Time Complexity

```text
O(N log N)
```

The rows are ordered by `turn` for the window function.

### Space Complexity

```text
O(N)
```

The CTE stores the cumulative weight for each row.

---

## Key SQL Concepts Used

- Common Table Expression
- Window Function
- Cumulative Sum
- `ORDER BY`
- `LIMIT`

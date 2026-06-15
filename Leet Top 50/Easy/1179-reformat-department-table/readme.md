# 1179. Reformat Department Table

## Problem

Given a `Department` table containing department revenue by month, reformat the table so that each department appears once, with a separate revenue column for each month.

The final table should contain:

- `id`
- `Jan_Revenue`
- `Feb_Revenue`
- `Mar_Revenue`
- `Apr_Revenue`
- `May_Revenue`
- `Jun_Revenue`
- `Jul_Revenue`
- `Aug_Revenue`
- `Sep_Revenue`
- `Oct_Revenue`
- `Nov_Revenue`
- `Dec_Revenue`

Return the result table in any order.

---

## Schema

### Department

| Column | Type |
|----------|---------|
| id | int |
| revenue | int |
| month | varchar |

- `(id, month)` is the primary key.
- Each row stores the revenue of one department for one month.
- `month` is one of `Jan`, `Feb`, `Mar`, `Apr`, `May`, `Jun`, `Jul`, `Aug`, `Sep`, `Oct`, `Nov`, or `Dec`.

---

## Solution

```sql
SELECT
    id,
    SUM(CASE WHEN month = 'Jan' THEN revenue END) AS Jan_Revenue,
    SUM(CASE WHEN month = 'Feb' THEN revenue END) AS Feb_Revenue,
    SUM(CASE WHEN month = 'Mar' THEN revenue END) AS Mar_Revenue,
    SUM(CASE WHEN month = 'Apr' THEN revenue END) AS Apr_Revenue,
    SUM(CASE WHEN month = 'May' THEN revenue END) AS May_Revenue,
    SUM(CASE WHEN month = 'Jun' THEN revenue END) AS Jun_Revenue,
    SUM(CASE WHEN month = 'Jul' THEN revenue END) AS Jul_Revenue,
    SUM(CASE WHEN month = 'Aug' THEN revenue END) AS Aug_Revenue,
    SUM(CASE WHEN month = 'Sep' THEN revenue END) AS Sep_Revenue,
    SUM(CASE WHEN month = 'Oct' THEN revenue END) AS Oct_Revenue,
    SUM(CASE WHEN month = 'Nov' THEN revenue END) AS Nov_Revenue,
    SUM(CASE WHEN month = 'Dec' THEN revenue END) AS Dec_Revenue
FROM Department
GROUP BY id;
```

---

## Approach

This problem is a classic SQL **pivot** problem.

The original table stores months vertically:

| id | month | revenue |
|---|---|---|
| 1 | Jan | 8000 |
| 1 | Feb | 7000 |
| 1 | Mar | 6000 |

We need to transform it horizontally:

| id | Jan_Revenue | Feb_Revenue | Mar_Revenue |
|---|---:|---:|---:|
| 1 | 8000 | 7000 | 6000 |

---

## How the Query Works

### 1. Group by Department

```sql
GROUP BY id
```

This creates one output row per department.

### 2. Use Conditional Aggregation

For each month, we extract revenue only when the row matches that month:

```sql
SUM(CASE WHEN month = 'Jan' THEN revenue END) AS Jan_Revenue
```

For department `1`, this means:

| month | revenue | CASE result |
|---|---:|---:|
| Jan | 8000 | 8000 |
| Feb | 7000 | NULL |
| Mar | 6000 | NULL |

After aggregation:

```text
Jan_Revenue = 8000
```

### 3. Missing Months Return NULL

If a department has no row for a month, all `CASE` results for that month are `NULL`.

Since `SUM(NULL)` returns `NULL`, the output correctly shows `NULL` for missing month revenue.

---

## Why `SUM()` Works Here

Because `(id, month)` is the primary key, each department can have at most one row per month.

So `SUM()` simply returns that month’s revenue value.

For example:

```sql
SUM(CASE WHEN month = 'Feb' THEN revenue END)
```

returns the February revenue for that department.

`MAX()` would also work:

```sql
MAX(CASE WHEN month = 'Feb' THEN revenue END)
```

But `SUM()` is commonly used for pivot-style aggregation.

---

## Complexity Analysis

Let:

- `N` = number of rows in the `Department` table

### Time Complexity

```text
O(N)
```

Each row is scanned once and evaluated against the monthly conditions.

### Space Complexity

```text
O(D)
```

Where `D` is the number of distinct departments grouped in memory.

---

## SQL Concepts Used

- `GROUP BY`
- `CASE WHEN`
- `SUM()`
- Conditional aggregation
- Pivoting rows into columns

---

## Key Takeaway

To pivot rows into columns in SQL, combine:

```sql
GROUP BY
```

with conditional aggregation:

```sql
SUM(CASE WHEN condition THEN value END)
```

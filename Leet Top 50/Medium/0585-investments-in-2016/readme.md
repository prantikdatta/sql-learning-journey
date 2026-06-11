# ⭐ 585. Investments in 2016

> One of the most frequently asked SQL interview questions involving **GROUP BY**, **HAVING**, duplicate detection, and filtering unique records.

## Problem Overview

We need to calculate the total `tiv_2016` investment value for policyholders who satisfy **both** of the following conditions:

1. Their `tiv_2015` value appears more than once in the table.
2. Their location `(lat, lon)` is unique across all policyholders.

The final answer must be rounded to **2 decimal places**.

---

## Intuition

This problem is essentially asking us to identify rows that belong to the intersection of two groups:

### Group 1: Duplicate `tiv_2015`

Find all investment values from 2015 that occur multiple times.

Example:

| tiv_2015 | Count |
| -------- | ----- |
| 10       | 3     |
| 20       | 1     |

Only `10` qualifies.

---

### Group 2: Unique Locations

Find locations that appear exactly once.

Example:

| lat | lon | Count |
| --- | --- | ----- |
| 10  | 10  | 1     |
| 20  | 20  | 2     |
| 40  | 40  | 1     |

Only `(10,10)` and `(40,40)` qualify.

---

### Final Step

Keep only rows that satisfy **both conditions**, then sum their `tiv_2016` values.

---

## Visual Walkthrough

### Original Data

| pid | tiv_2015 | tiv_2016 | lat | lon |
| --- | -------- | -------- | --- | --- |
| 1   | 10       | 5        | 10  | 10  |
| 2   | 20       | 20       | 20  | 20  |
| 3   | 10       | 30       | 20  | 20  |
| 4   | 10       | 40       | 40  | 40  |

### Duplicate `tiv_2015`

Rows retained:

| pid |
| --- |
| 1   |
| 3   |
| 4   |

---

### Unique Locations

Rows retained:

| pid |
| --- |
| 1   |
| 4   |

---

### Intersection

| pid | tiv_2016 |
| --- | -------- |
| 1   | 5        |
| 4   | 40       |

Result:

```text
5 + 40 = 45.00
```

---

## SQL Solution

```sql
SELECT
    ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM Insurance
WHERE tiv_2015 IN (
    SELECT tiv_2015
    FROM Insurance
    GROUP BY tiv_2015
    HAVING COUNT(*) > 1
)
AND (lat, lon) IN (
    SELECT lat, lon
    FROM Insurance
    GROUP BY lat, lon
    HAVING COUNT(*) = 1
);
```

---

## Why This Solution Works

### First Subquery

```sql
SELECT tiv_2015
FROM Insurance
GROUP BY tiv_2015
HAVING COUNT(*) > 1
```

Returns only investment values that occur multiple times.

---

### Second Subquery

```sql
SELECT lat, lon
FROM Insurance
GROUP BY lat, lon
HAVING COUNT(*) = 1
```

Returns only unique locations.

---

### Main Query

A row is included only if:

* Its `tiv_2015` belongs to the duplicate investment group.
* Its `(lat, lon)` belongs to the unique location group.

After filtering, we simply sum `tiv_2016`.

---

## Interview Takeaways

This problem tests several SQL concepts simultaneously:

✅ Aggregate Functions (`SUM`)
✅ Duplicate Detection (`COUNT > 1`)
✅ Unique Record Detection (`COUNT = 1`)
✅ `GROUP BY` + `HAVING`
✅ Composite Column Filtering `(lat, lon)`
✅ Nested Subqueries

Because it combines multiple filtering layers, it is a very common SQL interview question asked by product companies and data teams.

---

## Complexity Analysis

| Operation                       | Complexity |
| ------------------------------- | ---------- |
| Duplicate `tiv_2015` grouping   | O(n)       |
| Unique location grouping        | O(n)       |
| Final filtering and aggregation | O(n)       |

**Overall Time Complexity:** `O(n)`

**Space Complexity:** `O(n)`

---

## Key Learning

Whenever a SQL problem mentions:

* "appears more than once"
* "appears exactly once"
* "unique combination of columns"

think immediately about:

```sql
GROUP BY
HAVING COUNT(*)
```

This pattern appears repeatedly across SQL interview questions.

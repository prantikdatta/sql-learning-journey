````md
# ⭐ 585. Investments in 2016

## Problem

Given an `Insurance` table, report the sum of all `tiv_2016` values for policyholders who satisfy both conditions:

- They have the same `tiv_2015` value as one or more other policyholders.
- Their location `(lat, lon)` is unique.

Round the final result to two decimal places.

> **Note:** This is one of the most frequently asked SQL interview questions because it tests grouping, filtering, duplicate detection, and composite uniqueness.

## Table Schema

| Column Name | Type | Description |
|------------|------|-------------|
| pid | int | Policy ID |
| tiv_2015 | float | Total investment value in 2015 |
| tiv_2016 | float | Total investment value in 2016 |
| lat | float | Latitude |
| lon | float | Longitude |

## Approach

We need to filter rows using two separate conditions.

### Condition 1: Repeated `tiv_2015`

The policyholder must have a `tiv_2015` value that appears more than once.

```sql
SELECT tiv_2015
FROM Insurance
GROUP BY tiv_2015
HAVING COUNT(*) > 1
```

### Condition 2: Unique Location

The `(lat, lon)` pair must appear exactly once.

```sql
SELECT lat, lon
FROM Insurance
GROUP BY lat, lon
HAVING COUNT(*) = 1
```

After applying both filters, we calculate:

```sql
ROUND(SUM(tiv_2016), 2)
```

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

## Explanation

Using the sample data:

| pid | tiv_2015 | tiv_2016 | lat | lon |
|-----|----------|----------|-----|-----|
| 1 | 10 | 5 | 10 | 10 |
| 2 | 20 | 20 | 20 | 20 |
| 3 | 10 | 30 | 20 | 20 |
| 4 | 10 | 40 | 40 | 40 |

### Step 1: Find repeated `tiv_2015`

`tiv_2015 = 10` appears multiple times, so rows with this value pass the first condition.

### Step 2: Find unique locations

| Location | Count |
|----------|-------|
| (10, 10) | 1 |
| (20, 20) | 2 |
| (40, 40) | 1 |

Only `(10, 10)` and `(40, 40)` are unique.

### Step 3: Keep rows satisfying both conditions

| pid | tiv_2016 |
|-----|----------|
| 1 | 5 |
| 4 | 40 |

### Step 4: Sum and round

```text
5 + 40 = 45.00
```

## Complexity

- Time Complexity: `O(n)`
- Space Complexity: `O(n)`

## Key Concepts

- `GROUP BY`
- `HAVING`
- Duplicate detection
- Composite uniqueness using `(lat, lon)`
- Aggregate function `SUM()`
- Rounding using `ROUND()`

## Output

Returns the rounded sum of `tiv_2016` for policyholders whose `tiv_2015` is shared and whose location is unique.

## LeetCode Link

https://leetcode.com/problems/investments-in-2016/
````

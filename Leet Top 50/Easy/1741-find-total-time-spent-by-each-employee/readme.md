# 1741. Find Total Time Spent by Each Employee

## Problem

Given an `Employees` table containing office entry and exit times, calculate the total time each employee spent in the office for every day.

An employee may enter and leave the office multiple times during the same day.

The time spent for a single visit is:

```text
out_time - in_time
```

Return the result table in any order.

---

## Table Schema

```sql
Employees(
    emp_id INT,
    event_day DATE,
    in_time INT,
    out_time INT
)
```

- `(emp_id, event_day, in_time)` is the primary key.
- `in_time` and `out_time` represent minutes in the range `[1, 1440]`.
- It is guaranteed that:

```text
in_time < out_time
```

and intervals for the same employee on the same day do not overlap.

---

## Approach

For each office visit:

```text
time_spent = out_time - in_time
```

Since an employee can have multiple visits in one day, we:

1. Group rows by:
   - `event_day`
   - `emp_id`

2. Add up all durations using `SUM()`.

---

## Solution

```sql
SELECT
    event_day AS day,
    emp_id,
    SUM(out_time - in_time) AS total_time
FROM Employees
GROUP BY event_day, emp_id;
```

---

## Explanation

### Calculate Duration of Each Visit

```sql
out_time - in_time
```

gives the number of minutes spent during one entry.

---

### Group by Employee and Day

```sql
GROUP BY event_day, emp_id
```

All visits belonging to the same employee on the same day are collected together.

---

### Add the Durations

```sql
SUM(out_time - in_time)
```

computes the total time spent in the office that day.

---

## Example

Input:

| emp_id | event_day | in_time | out_time |
|--------:|------------|---------:|----------:|
| 1 | 2020-11-28 | 4 | 32 |
| 1 | 2020-11-28 | 55 | 200 |
| 1 | 2020-12-03 | 1 | 42 |
| 2 | 2020-11-28 | 3 | 33 |
| 2 | 2020-12-09 | 47 | 74 |

### Calculations

Employee 1:

- 2020-11-28:

```text
(32 - 4) + (200 - 55)
= 28 + 145
= 173
```

- 2020-12-03:

```text
42 - 1 = 41
```

Employee 2:

- 2020-11-28:

```text
33 - 3 = 30
```

- 2020-12-09:

```text
74 - 47 = 27
```

Output:

| day | emp_id | total_time |
|------|--------:|------------:|
| 2020-11-28 | 1 | 173 |
| 2020-11-28 | 2 | 30 |
| 2020-12-03 | 1 | 41 |
| 2020-12-09 | 2 | 27 |

---

## Complexity Analysis

Let **n** be the number of rows in the table.

- **Time Complexity:** `O(n)`
- **Space Complexity:** `O(k)`

where **k** is the number of distinct `(event_day, emp_id)` pairs.

---

## Key Concepts

This problem illustrates:

- Aggregation with `SUM()`
- Grouping records using `GROUP BY`
- Column aliasing using `AS`

The overall idea is to compute the duration of each office visit and aggregate those durations for each employee on each day.

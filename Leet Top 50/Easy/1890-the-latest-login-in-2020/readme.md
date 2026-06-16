# 1890. The Latest Login in 2020

## Problem

Given a `Logins` table containing login timestamps for users, report the latest login for each user during the year **2020**.

Users who did not log in during 2020 should not appear in the result.

Return the result in any order.

---

## Table Schema

```sql
Logins(
    user_id INT,
    time_stamp DATETIME
)
```

- `(user_id, time_stamp)` is the primary key.
- Each row represents one login event.

---

## Approach

We only care about logins that occurred in **2020**.

For each user:

1. Filter rows whose `time_stamp` belongs to the year 2020.
2. Group records by `user_id`.
3. Use `MAX(time_stamp)` to obtain the most recent login timestamp.

---

## Solution

```sql
SELECT
    user_id,
    MAX(time_stamp) AS last_stamp
FROM Logins
WHERE YEAR(time_stamp) = 2020
GROUP BY user_id;
```

---

## Explanation

### Step 1: Keep only 2020 logins

```sql
WHERE YEAR(time_stamp) = 2020
```

This removes all login records from other years.

### Step 2: Group by user

```sql
GROUP BY user_id
```

All login events belonging to the same user are grouped together.

### Step 3: Find the latest login

```sql
MAX(time_stamp)
```

Since later timestamps are larger, `MAX()` returns the user's most recent login in 2020.

---

## Example

Input:

| user_id | time_stamp |
|---------:|------------|
| 6 | 2020-06-30 15:06:07 |
| 6 | 2021-04-21 14:06:06 |
| 6 | 2019-03-07 00:18:15 |
| 8 | 2020-02-01 05:10:53 |
| 8 | 2020-12-30 00:46:50 |
| 2 | 2020-01-16 02:49:50 |
| 2 | 2019-08-25 07:59:08 |
| 14 | 2019-07-14 09:00:00 |
| 14 | 2021-01-06 11:59:59 |

Output:

| user_id | last_stamp |
|---------:|------------|
| 6 | 2020-06-30 15:06:07 |
| 8 | 2020-12-30 00:46:50 |
| 2 | 2020-01-16 02:49:50 |

---

## Complexity Analysis

Let **n** be the number of rows in the table.

- **Time Complexity:** `O(n)`
- **Space Complexity:** `O(k)`

where **k** is the number of users who logged in during 2020.

---

## Key Concept

This problem combines:

- **Filtering rows** using `WHERE`
- **Grouping records** using `GROUP BY`
- **Aggregate functions** using `MAX()`

to determine the latest event for each user within a specific year.

# ⭐ 180. Consecutive Numbers

> A classic SQL interview question that introduces **window functions** and demonstrates how to compare adjacent rows without using self-joins.

## Problem Overview

Given a table of logs, find all numbers that appear **at least three times consecutively**.

### Example

| id | num |
| -- | --- |
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |

Output:

| ConsecutiveNums |
| --------------- |
| 1               |

Because `1` appears three times in a row.

---

## Intuition

When a problem asks:

* Previous row
* Next row
* Consecutive records
* Running comparisons

you should immediately think about **Window Functions**.

The key observation:

For a number to appear at least three times consecutively, the current value must be equal to:

* The previous row's value
* The value two rows before

In other words:

```text
Current = Previous = Two Rows Before
```

---

## Visual Walkthrough

### Original Table

| id | num |
| -- | --- |
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |

---

### Apply LAG()

```sql
LAG(num, 1)
LAG(num, 2)
```

Result:

| id | num | prev1 | prev2 |
| -- | --- | ----- | ----- |
| 1  | 1   | NULL  | NULL  |
| 2  | 1   | 1     | NULL  |
| 3  | 1   | 1     | 1     |
| 4  | 2   | 1     | 1     |
| 5  | 1   | 2     | 1     |
| 6  | 2   | 1     | 2     |
| 7  | 2   | 2     | 1     |

---

### Find Consecutive Triplets

We only keep rows where:

```text
num = prev1
AND
num = prev2
```

Checking row by row:

| id | Condition |
| -- | --------- |
| 1  | ❌         |
| 2  | ❌         |
| 3  | ✅         |
| 4  | ❌         |
| 5  | ❌         |
| 6  | ❌         |
| 7  | ❌         |

Row 3 satisfies the condition, meaning:

```text
1 → 1 → 1
```

appears consecutively.

---

## Why DISTINCT Is Needed

Consider:

| id | num |
| -- | --- |
| 1  | 5   |
| 2  | 5   |
| 3  | 5   |
| 4  | 5   |

Rows 3 and 4 would both satisfy:

```text
num = prev1 = prev2
```

Without `DISTINCT`, the output would contain duplicate `5`s.

Using:

```sql
SELECT DISTINCT num
```

ensures each qualifying number appears only once.

---

## SQL Solution

```sql
SELECT DISTINCT
    num AS ConsecutiveNums
FROM (
    SELECT
        num,
        LAG(num, 1) OVER (ORDER BY id) AS prev_num_1,
        LAG(num, 2) OVER (ORDER BY id) AS prev_num_2
    FROM Logs
) l
WHERE num = prev_num_1
  AND num = prev_num_2;
```

---

## Alternative Solution (Self Join)

Before window functions became popular, this problem was often solved using self joins:

```sql
SELECT DISTINCT l1.num AS ConsecutiveNums
FROM Logs l1
JOIN Logs l2
    ON l1.id = l2.id + 1
JOIN Logs l3
    ON l2.id = l3.id + 1
WHERE l1.num = l2.num
  AND l2.num = l3.num;
```

While correct, the window function solution is cleaner and easier to scale.

---

## Interview Takeaways

This problem is frequently used to test:

✅ Window Functions (`LAG`)
✅ Row-to-row comparison
✅ Consecutive sequence detection
✅ Alternative approaches (Self Join vs Window Functions)
✅ Understanding ordered datasets

---

## Complexity Analysis

### Window Function Solution

| Operation          | Complexity |
| ------------------ | ---------- |
| Window computation | O(n)       |
| Filtering          | O(n)       |

**Time Complexity:** `O(n)`

**Space Complexity:** `O(n)`

---

## Key Learning

Whenever you encounter:

* Consecutive rows
* Previous row comparisons
* Sequence detection
* Running patterns

consider using:

```sql
LAG()
LEAD()
ROW_NUMBER()
```

These window functions are among the most important SQL interview tools and often lead to cleaner solutions than multiple self joins.

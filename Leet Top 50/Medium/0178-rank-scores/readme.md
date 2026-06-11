# ⭐ 178. Rank Scores

> One of the most important SQL interview questions for understanding ranking functions. This problem is frequently used to test whether candidates know the difference between `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()`.

## Problem Overview

Given a table of scores, assign a rank to each score according to the following rules:

* Higher scores receive better ranks.
* Equal scores receive the same rank.
* Rankings must remain consecutive.
* No gaps are allowed after ties.

### Example

Input:

| score |
| ----- |
| 4.00  |
| 4.00  |
| 3.85  |
| 3.65  |
| 3.65  |
| 3.50  |

Output:

| score | rank |
| ----- | ---- |
| 4.00  | 1    |
| 4.00  | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.50  | 4    |

---

## The Key Observation

The phrase:

> "There should be no holes between ranks"

is the biggest clue in this problem.

When interviewers include this statement, they are typically expecting the use of:

```sql
DENSE_RANK()
```

---

## Understanding SQL Ranking Functions

Before solving the problem, it is important to understand the three ranking functions that are often confused.

Consider the following scores:

| score |
| ----- |
| 100   |
| 100   |
| 90    |
| 80    |

---

### ROW_NUMBER()

Assigns a unique number to every row.

```sql
ROW_NUMBER() OVER (ORDER BY score DESC)
```

Result:

| score | row_number |
| ----- | ---------- |
| 100   | 1          |
| 100   | 2          |
| 90    | 3          |
| 80    | 4          |

Use when every row must have a unique position.

---

### RANK()

Assigns the same rank to tied values but leaves gaps.

```sql
RANK() OVER (ORDER BY score DESC)
```

Result:

| score | rank |
| ----- | ---- |
| 100   | 1    |
| 100   | 1    |
| 90    | 3    |
| 80    | 4    |

Notice:

```text
Rank 2 is missing
```

This is called a ranking gap.

---

### DENSE_RANK()

Assigns the same rank to tied values and does not leave gaps.

```sql
DENSE_RANK() OVER (ORDER BY score DESC)
```

Result:

| score | dense_rank |
| ----- | ---------- |
| 100   | 1          |
| 100   | 1          |
| 90    | 2          |
| 80    | 3          |

This exactly matches the requirement.

---

## Why DENSE_RANK Is Correct

The problem states:

```text
If there is a tie, both scores should have the same ranking.
After a tie, the next ranking number should be the next consecutive integer.
```

This is the textbook definition of:

```sql
DENSE_RANK()
```

---

## Visual Walkthrough

### Original Data

| id | score |
| -- | ----- |
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |

---

### Order Scores Descending

| score |
| ----- |
| 4.00  |
| 4.00  |
| 3.85  |
| 3.65  |
| 3.65  |
| 3.50  |

---

### Apply DENSE_RANK()

| score | rank |
| ----- | ---- |
| 4.00  | 1    |
| 4.00  | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.50  | 4    |

No ranks are skipped.

---

## SQL Solution

```sql
SELECT
    score,
    DENSE_RANK() OVER (
        ORDER BY score DESC
    ) AS `rank`
FROM Scores;
```

---

## How the Window Function Works

```sql
DENSE_RANK() OVER (
    ORDER BY score DESC
)
```

### Step 1

Sort scores from highest to lowest.

```text
4.00
4.00
3.85
3.65
3.65
3.50
```

### Step 2

Assign ranks to distinct score values.

```text
4.00 → Rank 1
3.85 → Rank 2
3.65 → Rank 3
3.50 → Rank 4
```

### Step 3

Apply those ranks back to every row.

---

## Interview Takeaways

This problem is commonly asked because it verifies whether you understand:

✅ Window Functions

✅ Ranking Problems

✅ `ROW_NUMBER()`

✅ `RANK()`

✅ `DENSE_RANK()`

✅ Handling Ties

Many follow-up interview questions are simply variations of this concept.

---

## Complexity Analysis

### Time Complexity

The database must sort the scores:

```text
O(n log n)
```

### Space Complexity

```text
O(n)
```

for the ranking operation.

---

## Common Interview Follow-Up

### Q: When would you use `RANK()` instead?

Use `RANK()` when ranking gaps should be preserved.

Example:

```text
1st Place
1st Place
3rd Place
```

Sports leaderboards often use this behavior.

---

### Q: When would you use `ROW_NUMBER()`?

Use `ROW_NUMBER()` when every row must receive a unique position, even when values are identical.

---

## Key Learning

Whenever a problem contains phrases like:

* "Assign ranks"
* "Handle ties"
* "Leaderboard"
* "Top performers"
* "No gaps between ranks"

immediately think about:

```sql
ROW_NUMBER()
RANK()
DENSE_RANK()
```

and decide which ranking behavior matches the requirements.

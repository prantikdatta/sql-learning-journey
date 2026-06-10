# 626. Exchange Seats

## Problem

The `Seat` table contains student seat assignments.

Each row contains:

- `id` → seat number
- `student` → student name

The seat IDs:

- Start from `1`
- Increase continuously

Swap every pair of consecutive students:

```text
1 ↔ 2
3 ↔ 4
5 ↔ 6
...
```

If the number of students is odd, the last student remains in the same seat.

Return the result ordered by `id`.

---

## Approach

### Step 1: Handle even IDs

For even seat IDs, swap with the previous seat.

```sql
id - 1
```

Example:

```text
2 → 1
4 → 3
6 → 5
```

---

### Step 2: Handle odd IDs

For odd seat IDs (except the last student), swap with the next seat.

```sql
id + 1
```

Example:

```text
1 → 2
3 → 4
5 → 6
```

---

### Step 3: Handle the last student

If the total number of students is odd, the last student remains unchanged.

```sql
id = MAX(id)
```

Example:

```text
1 2 3 4 5

5 remains 5
```

---

### Step 4: Reorder seats

After generating the new seat IDs, sort by the new `id`.

```sql
ORDER BY id
```

This displays the swapped seating arrangement.

---

## Solution

```sql
SELECT
    CASE
        WHEN id % 2 = 0 THEN id - 1
        WHEN id % 2 = 1
             AND id != (SELECT MAX(id) FROM Seat)
            THEN id + 1
        ELSE id
    END AS id,
    student
FROM Seat
ORDER BY id;
```

---

## Example Walkthrough

### Input

| id | student |
|----|----------|
| 1 | Abbot |
| 2 | Doris |
| 3 | Emerson |
| 4 | Green |
| 5 | Jeames |

### After Swapping

| New id | student |
|---------|----------|
| 1 | Doris |
| 2 | Abbot |
| 3 | Green |
| 4 | Emerson |
| 5 | Jeames |

---

## Complexity Analysis

### Time Complexity

```text
O(N)
```

Each row is processed exactly once.

### Space Complexity

```text
O(1)
```

No additional storage is required apart from the result set.

---

## Key SQL Concepts Used

- `CASE WHEN`
- Modulo Operator (`%`)
- Scalar Subquery
- `MAX`
- Conditional Transformation
- `ORDER BY`

---

## Interview Takeaway

This is a classic **conditional row transformation** problem.

The key observation is:

```text
Even ID  -> Move back by 1
Odd ID   -> Move forward by 1
Last Odd -> Stay unchanged
```

Rather than physically swapping rows, we generate the new seat IDs using a `CASE` expression and then sort by the updated IDs.

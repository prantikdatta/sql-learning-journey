# 1050. Actors and Directors Who Cooperated At Least Three Times

## Problem

Given the following table:

### ActorDirector

| Column Name | Type |
|------------|------|
| actor_id | int |
| director_id | int |
| timestamp | int |

- `timestamp` is the primary key.
- Each row represents one cooperation between an actor and a director.

## Objective

Find all `(actor_id, director_id)` pairs where:

```text
The actor and director have cooperated at least 3 times.
```

Return the result table in any order.

---

## Approach

Each row represents one collaboration.

To determine how many times an actor worked with a director:

1. Group records by:
   - `actor_id`
   - `director_id`
2. Count the number of rows in each group.
3. Keep only groups where the count is at least 3.

---

## SQL Solution

```sql
SELECT
    actor_id,
    director_id
FROM ActorDirector
GROUP BY actor_id, director_id
HAVING COUNT(*) >= 3;
```

---

## Explanation

### Step 1: Group Collaborations

```sql
GROUP BY actor_id, director_id
```

Creates one group for each actor-director pair.

Example:

| actor_id | director_id | collaborations |
|-----------|-------------|---------------|
| 1 | 1 | 3 |
| 1 | 2 | 2 |
| 2 | 1 | 2 |

---

### Step 2: Count Collaborations

```sql
COUNT(*)
```

Counts the number of rows in each group.

Since every row represents one cooperation:

```text
COUNT(*) = number of collaborations
```

---

### Step 3: Filter Qualified Pairs

```sql
HAVING COUNT(*) >= 3
```

Keeps only actor-director pairs that collaborated at least three times.

---

## Example Walkthrough

### Input

| actor_id | director_id | timestamp |
|-----------|-------------|-----------|
| 1 | 1 | 0 |
| 1 | 1 | 1 |
| 1 | 1 | 2 |
| 1 | 2 | 3 |
| 1 | 2 | 4 |
| 2 | 1 | 5 |
| 2 | 1 | 6 |

---

### Grouped Results

| actor_id | director_id | count |
|-----------|-------------|--------|
| 1 | 1 | 3 |
| 1 | 2 | 2 |
| 2 | 1 | 2 |

---

### After HAVING Filter

```sql
HAVING COUNT(*) >= 3
```

| actor_id | director_id |
|-----------|-------------|
| 1 | 1 |

---

## Why HAVING Instead of WHERE?

### Incorrect

```sql
WHERE COUNT(*) >= 3
```

This causes an error because:

```text
WHERE filters rows before grouping.
```

Aggregate functions like `COUNT()` are not available in `WHERE`.

---

### Correct

```sql
HAVING COUNT(*) >= 3
```

Because:

```text
HAVING filters groups after aggregation.
```

---

## Complexity Analysis

Let:

- `n` = number of rows in `ActorDirector`

### Time Complexity

```text
O(n)
```

One pass to group and count records.

### Space Complexity

```text
O(k)
```

Where:

```text
k = number of unique (actor_id, director_id) pairs
```

stored during aggregation.

---

## Key SQL Concepts

- GROUP BY
- Aggregate Functions
- COUNT()
- HAVING Clause
- Group Filtering
- Aggregation Queries

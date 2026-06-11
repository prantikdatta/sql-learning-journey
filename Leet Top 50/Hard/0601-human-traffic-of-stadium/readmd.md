# ⭐ 601. Human Traffic of Stadium

## Problem

Given a `Stadium` table, return all records that are part of a group of at least three consecutive `id` values where each row has `people >= 100`.

The final result should be ordered by `visit_date`.

## SQL Pattern

Gaps and Islands using `DENSE_RANK()`.

## Approach

First, filter only rows where:

```sql
people >= 100
```

After filtering, we need to detect consecutive `id` groups.

For consecutive numbers, this expression remains constant within the same group:

```sql
id - DENSE_RANK() OVER (ORDER BY id)
```

Example:

| id | dense_rank | id - dense_rank |
|----|------------|-----------------|
| 5 | 1 | 4 |
| 6 | 2 | 4 |
| 7 | 3 | 4 |
| 8 | 4 | 4 |

Since all rows have the same value `4`, they belong to the same consecutive group.

After creating these groups, keep only groups having at least three rows.

## SQL Solution

```sql
SELECT id, visit_date, people
FROM (
    SELECT *,
           id - DENSE_RANK() OVER (ORDER BY id) AS grp
    FROM Stadium
    WHERE people >= 100
) t
WHERE grp IN (
    SELECT grp
    FROM (
        SELECT id - DENSE_RANK() OVER (ORDER BY id) AS grp
        FROM Stadium
        WHERE people >= 100
    ) x
    GROUP BY grp
    HAVING COUNT(*) >= 3
)
ORDER BY visit_date;
```

## Example

### Stadium

| id | visit_date | people |
|----|------------|--------|
| 1 | 2017-01-01 | 10 |
| 2 | 2017-01-02 | 109 |
| 3 | 2017-01-03 | 150 |
| 4 | 2017-01-04 | 99 |
| 5 | 2017-01-05 | 145 |
| 6 | 2017-01-06 | 1455 |
| 7 | 2017-01-07 | 199 |
| 8 | 2017-01-09 | 188 |

### Step 1: Keep rows with people >= 100

| id | visit_date | people |
|----|------------|--------|
| 2 | 2017-01-02 | 109 |
| 3 | 2017-01-03 | 150 |
| 5 | 2017-01-05 | 145 |
| 6 | 2017-01-06 | 1455 |
| 7 | 2017-01-07 | 199 |
| 8 | 2017-01-09 | 188 |

### Step 2: Create consecutive groups

| id | dense_rank | grp |
|----|------------|-----|
| 2 | 1 | 1 |
| 3 | 2 | 1 |
| 5 | 3 | 2 |
| 6 | 4 | 2 |
| 7 | 5 | 2 |
| 8 | 6 | 2 |

### Step 3: Keep groups with at least 3 rows

Group `1` contains ids `2, 3`, so it is ignored.

Group `2` contains ids `5, 6, 7, 8`, so it is returned.

### Output

| id | visit_date | people |
|----|------------|--------|
| 5 | 2017-01-05 | 145 |
| 6 | 2017-01-06 | 1455 |
| 7 | 2017-01-07 | 199 |
| 8 | 2017-01-09 | 188 |

## Complexity

- Time Complexity: `O(n log n)`
- Space Complexity: `O(n)`

Where `n` is the number of rows in `Stadium`.

## Key Takeaways

- This is a classic gaps and islands problem.
- Filter invalid rows before detecting consecutive sequences.
- `id - DENSE_RANK()` stays constant for consecutive `id` groups.
- The problem depends on consecutive `id` values, not consecutive dates.
- Use `HAVING COUNT(*) >= 3` to keep only valid groups.

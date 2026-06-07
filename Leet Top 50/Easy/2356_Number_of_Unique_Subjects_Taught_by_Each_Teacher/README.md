# 2356. Number of Unique Subjects Taught by Each Teacher

## Approach

A teacher may teach the same subject in multiple departments.

Since we need the number of **unique subjects** taught by each teacher:

1. Group rows by `teacher_id`.
2. Use `COUNT(DISTINCT subject_id)` to count each subject only once.

## SQL

```sql
SELECT
    teacher_id,
    COUNT(DISTINCT subject_id) AS cnt
FROM Teacher
GROUP BY teacher_id;
```

## Example

Input:

| teacher_id | subject_id | dept_id |
|------------|------------|----------|
| 1 | 2 | 3 |
| 1 | 2 | 4 |
| 1 | 3 | 3 |
| 2 | 1 | 1 |
| 2 | 2 | 1 |
| 2 | 3 | 1 |
| 2 | 4 | 1 |

Output:

| teacher_id | cnt |
|------------|-----|
| 1 | 2 |
| 2 | 4 |

Explanation:

- Teacher 1 teaches subjects **2** and **3** → `2` unique subjects.
- Teacher 2 teaches subjects **1, 2, 3, 4** → `4` unique subjects.

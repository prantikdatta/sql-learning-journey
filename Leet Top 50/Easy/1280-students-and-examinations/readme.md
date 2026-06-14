# 1280. Students and Examinations

## Problem

Find the number of times each student attended each exam.

The result must include every student and every subject, even when the student did not attend that subject's exam.

## Table Schema

### Students

| Column Name  | Type    |
| ------------ | ------- |
| student_id   | int     |
| student_name | varchar |

### Subjects

| Column Name  | Type    |
| ------------ | ------- |
| subject_name | varchar |

### Examinations

| Column Name  | Type    |
| ------------ | ------- |
| student_id   | int     |
| subject_name | varchar |

## Approach

1. Use `CROSS JOIN` between `Students` and `Subjects` to generate every possible student-subject pair.
2. Use `LEFT JOIN` with `Examinations` to keep pairs even when no exam was attended.
3. Count matched examination records for each student-subject pair.
4. Order the final result by `student_id` and `subject_name`.

## SQL Solution

```sql
SELECT
    s.student_id,
    s.student_name,
    su.subject_name,
    COUNT(e.subject_name) AS attended_exams
FROM Students s
CROSS JOIN Subjects su
LEFT JOIN Examinations e
    ON s.student_id = e.student_id
   AND su.subject_name = e.subject_name
GROUP BY
    s.student_id,
    s.student_name,
    su.subject_name
ORDER BY
    s.student_id,
    su.subject_name;
```

## Explanation

- `CROSS JOIN` creates all combinations of students and subjects.
- `LEFT JOIN` attaches matching exam records when they exist.
- `COUNT(e.subject_name)` counts only non-null matches from `Examinations`.
- Students with no exam records still appear because of the `LEFT JOIN`.
- Missing exam records are counted as `0`.

## Example Output

| student_id | student_name | subject_name | attended_exams |
| ---------- | ------------ | ------------ | -------------- |
| 1          | Alice        | Math         | 3              |
| 1          | Alice        | Physics      | 2              |
| 1          | Alice        | Programming  | 1              |
| 2          | Bob          | Math         | 1              |
| 2          | Bob          | Physics      | 0              |
| 2          | Bob          | Programming  | 1              |

## Complexity Analysis

- Time Complexity: `O(s × u + e)`
- Space Complexity: `O(s × u)`

Where:

- `s` = number of students
- `u` = number of subjects
- `e` = number of examination records

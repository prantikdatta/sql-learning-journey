# 596. Classes More Than 5 Students

## Problem

Given a table `Courses`, find all classes that have at least five students.

## Table Schema

| Column  | Type    |
|---------|---------|
| student | varchar |
| class   | varchar |

`(student, class)` is the primary key, so each student-class enrollment pair is unique.

## Approach

Group the rows by `class`, then count how many students are enrolled in each class.

Only keep classes where the count is at least `5`.

## SQL Solution

```sql
SELECT class
FROM Courses
GROUP BY class
HAVING COUNT(*) >= 5;

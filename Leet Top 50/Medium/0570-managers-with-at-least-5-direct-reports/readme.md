# 570. Managers with at Least 5 Direct Reports

## Difficulty
Medium

## Problem Statement

Given an `Employee` table, find the managers who have at least five direct reports.

### Employee Table

| Column Name | Type |
|------------|------|
| id | int |
| name | varchar |
| department | varchar |
| managerId | int |

- `id` is the primary key.
- `managerId` references the `id` of the employee's manager.
- If `managerId` is `NULL`, the employee does not have a manager.
- No employee manages themself.

## Approach

Since managers and employees are stored in the same table, a **self join** is required.

1. Treat one instance of the table as the manager (`e`).
2. Treat the other instance as the direct report (`r`).
3. Join on `e.id = r.managerId`.
4. Group records by manager.
5. Count the number of direct reports for each manager.
6. Return managers having at least 5 direct reports.

## SQL Solution

```sql
SELECT e.name
FROM Employee e
JOIN Employee r
    ON e.id = r.managerId
GROUP BY e.id, e.name
HAVING COUNT(*) >= 5;
```

## Explanation

### Before Grouping

| Manager | Report |
|----------|---------|
| John | Dan |
| John | James |
| John | Amy |
| John | Anne |
| John | Ron |

### After Grouping

| Manager | Direct Reports |
|----------|----------------|
| John | 5 |

Since John has at least 5 direct reports, he is included in the result.

## Complexity Analysis

| Metric | Complexity |
|----------|------------|
| Time | O(n) |
| Space | O(1) |

## Key Concepts

- Self Join
- GROUP BY
- Aggregate Functions (`COUNT`)
- HAVING Clause

## LeetCode Link

https://leetcode.com/problems/managers-with-at-least-5-direct-reports/

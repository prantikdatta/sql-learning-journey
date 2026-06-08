# Patients With a Condition

## Problem

Table: `Patients`

| Column Name  | Type    |
|-------------|---------|
| patient_id  | int     |
| patient_name| varchar |
| conditions  | varchar |

- `patient_id` is the primary key.
- `conditions` contains 0 or more condition codes separated by spaces.
- Type I Diabetes always starts with the prefix `DIAB1`.

Find the `patient_id`, `patient_name`, and `conditions` of patients who have Type I Diabetes.

## Solution

```sql
SELECT *
FROM Patients
WHERE conditions LIKE 'DIAB1%'
   OR conditions LIKE '% DIAB1%';
```

## Explanation

A patient has Type I Diabetes if any condition code starts with `DIAB1`.

The query checks:

1. `conditions LIKE 'DIAB1%'`
   - The first condition starts with `DIAB1`.

2. `conditions LIKE '% DIAB1%'`
   - A condition starting with `DIAB1` appears later in the string and is preceded by a space.

This ensures that only complete condition codes beginning with `DIAB1` are matched.

## Complexity Analysis

- Time Complexity: **O(n)**
- Space Complexity: **O(1)**

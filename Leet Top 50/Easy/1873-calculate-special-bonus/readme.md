# 1873. Calculate Special Bonus

## Problem

Given an `Employees` table containing employee information, calculate the bonus for each employee.

An employee receives a bonus equal to **100% of their salary** if:

1. Their `employee_id` is an odd number.
2. Their name does **not** start with the character `'M'`.

Otherwise, the bonus is `0`.

Return the result ordered by `employee_id`.

---

## Table Schema

```sql
Employees(
    employee_id INT,
    name VARCHAR,
    salary INT
)
```

- `employee_id` is the primary key.
- Each row stores an employee's name and salary.

---

## Approach

For every employee:

- Check whether the employee ID is odd.
- Verify that the employee's name does not begin with `'M'`.
- If both conditions are satisfied, the bonus equals the employee's salary.
- Otherwise, the bonus is `0`.

This can be implemented using a `CASE` expression.

---

## Solution

```sql
SELECT
    employee_id,
    CASE
        WHEN employee_id % 2 = 1
             AND name NOT LIKE 'M%'
        THEN salary
        ELSE 0
    END AS bonus
FROM Employees
ORDER BY employee_id;
```

---

## Explanation

### Odd Employee ID

```sql
employee_id % 2 = 1
```

Checks whether the employee ID is odd.

---

### Name Does Not Start with 'M'

```sql
name NOT LIKE 'M%'
```

- `M%` matches any name beginning with `M`.
- `NOT LIKE` excludes such names.

---

### Assign Bonus

```sql
CASE
    WHEN ...
    THEN salary
    ELSE 0
END
```

- Eligible employees receive a bonus equal to their salary.
- All others receive zero.

---

## Example

Input:

| employee_id | name | salary |
|------------:|------|--------:|
| 2 | Meir | 3000 |
| 3 | Michael | 3800 |
| 7 | Addilyn | 7400 |
| 8 | Juan | 6100 |
| 9 | Kannon | 7700 |

Output:

| employee_id | bonus |
|------------:|------:|
| 2 | 0 |
| 3 | 0 |
| 7 | 7400 |
| 8 | 0 |
| 9 | 7700 |

---

## Complexity Analysis

Let **n** be the number of employees.

- **Time Complexity:** `O(n)`
- **Space Complexity:** `O(1)`

---

## Key Concepts

This problem demonstrates:

- Conditional logic with `CASE`
- Pattern matching using `LIKE`
- Checking parity with the modulo operator `%`

Together, these allow us to compute employee bonuses efficiently in a single query.

# 1378. Replace Employee ID With The Unique Identifier

## Problem

Given two tables:

### Employees

| Column Name | Type |
|------------|------|
| id | int |
| name | varchar |

- `id` is the primary key.
- Contains employee information.

### EmployeeUNI

| Column Name | Type |
|------------|------|
| id | int |
| unique_id | int |

- `(id, unique_id)` is the primary key.
- Stores the unique identifier associated with an employee.

## Objective

Report:

- `unique_id`
- `name`

for every employee.

If an employee does not have a corresponding `unique_id`, return `NULL`.

Return the result table in any order.

---

## Approach

Since every employee must appear in the result, we start with the `Employees` table.

Some employees may not have an entry in `EmployeeUNI`, so we use a:

```sql
LEFT JOIN
```

This ensures:

- All employees are included.
- Missing matches automatically produce `NULL` values for `unique_id`.

---

## SQL Solution

```sql
SELECT
    eu.unique_id,
    e.name
FROM Employees e
LEFT JOIN EmployeeUNI eu
    ON e.id = eu.id;
```

---

## Explanation

### Step 1: Start with Employees

```sql
FROM Employees e
```

This guarantees every employee appears in the output.

### Step 2: Match Unique IDs

```sql
LEFT JOIN EmployeeUNI eu
    ON e.id = eu.id
```

Matches each employee with their unique identifier.

### Step 3: Return Required Columns

```sql
SELECT
    eu.unique_id,
    e.name
```

Outputs the unique identifier and employee name.

If no match exists, `unique_id` becomes `NULL`.

---

## Example

### Input

#### Employees

| id | name |
|----|---------|
| 1 | Alice |
| 7 | Bob |
| 11 | Meir |
| 90 | Winston |
| 3 | Jonathan |

#### EmployeeUNI

| id | unique_id |
|----|-----------|
| 3 | 1 |
| 11 | 2 |
| 90 | 3 |

### Output

| unique_id | name |
|-----------|----------|
| NULL | Alice |
| NULL | Bob |
| 2 | Meir |
| 3 | Winston |
| 1 | Jonathan |

---

## Why LEFT JOIN?

### INNER JOIN

```sql
SELECT *
FROM Employees e
INNER JOIN EmployeeUNI eu
ON e.id = eu.id;
```

Would exclude:

- Alice
- Bob

because they do not have matching records.

### LEFT JOIN

```sql
SELECT *
FROM Employees e
LEFT JOIN EmployeeUNI eu
ON e.id = eu.id;
```

Keeps all employees and fills unmatched values with `NULL`.

This is exactly what the problem requires.

---

## Complexity Analysis

Let:

- `E` = number of employees
- `U` = number of rows in EmployeeUNI

### Time Complexity

```text
O(E + U)
```

with indexed joins.

### Space Complexity

```text
O(1)
```

excluding the output result.

---

## Key SQL Concepts

- LEFT JOIN
- Handling NULL values
- Primary Key Relationships
- Data Enrichment Through Joins

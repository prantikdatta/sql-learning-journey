# 1907. Count Salary Categories

## Problem

The `Accounts` table contains monthly income information for bank accounts.

Each account belongs to exactly one salary category:

- **Low Salary**: income strictly less than `20000`
- **Average Salary**: income between `20000` and `50000`, inclusive
- **High Salary**: income strictly greater than `50000`

Return the number of accounts in each category.

The result must contain all three categories, even if a category has `0` accounts.

---

## Approach 1: Category Table + Left Join

### Step 1: Create all required salary categories

Create a temporary category table using `UNION ALL`.

```sql
WITH cat AS (
    SELECT 'Low Salary' AS category

    UNION ALL

    SELECT 'Average Salary'

    UNION ALL

    SELECT 'High Salary'
)
```

This ensures all three categories appear in the final output.

---

### Step 2: Assign each account to a category

Use a `CASE` statement to classify each account based on income.

```sql
CASE
    WHEN income < 20000 THEN 'Low Salary'
    WHEN income BETWEEN 20000 AND 50000 THEN 'Average Salary'
    ELSE 'High Salary'
END
```

---

### Step 3: Left join categories with account categories

Use `LEFT JOIN` so categories with no accounts still appear.

```sql
LEFT JOIN acc a
    ON c.category = a.category
```

Then count matching accounts per category.

---

## Solution 1

```sql
WITH cat AS (
    SELECT 'Low Salary' AS category

    UNION ALL

    SELECT 'Average Salary'

    UNION ALL

    SELECT 'High Salary'
),
acc AS (
    SELECT
        CASE
            WHEN income < 20000 THEN 'Low Salary'
            WHEN income BETWEEN 20000 AND 50000 THEN 'Average Salary'
            ELSE 'High Salary'
        END AS category
    FROM Accounts
)

SELECT
    c.category,
    COUNT(a.category) AS accounts_count
FROM cat c
LEFT JOIN acc a
    ON c.category = a.category
GROUP BY c.category;
```

---

## Approach 2: Direct Conditional Queries

Run three separate count queries, one for each category, and combine them using `UNION`.

This works well because each query always returns one row, even when the count is `0`.

---

## Solution 2

```sql
SELECT
    'Low Salary' AS category,
    COUNT(*) AS accounts_count
FROM Accounts
WHERE income < 20000

UNION

SELECT
    'Average Salary' AS category,
    COUNT(*) AS accounts_count
FROM Accounts
WHERE income BETWEEN 20000 AND 50000

UNION

SELECT
    'High Salary' AS category,
    COUNT(*) AS accounts_count
FROM Accounts
WHERE income > 50000;
```

---

## Complexity Analysis

### Time Complexity

```text
O(N)
```

Each account is scanned and categorized.

### Space Complexity

```text
O(1)
```

Only three salary categories are stored.

---

## Key SQL Concepts Used

- `CASE WHEN`
- `UNION`
- `UNION ALL`
- Common Table Expression
- `LEFT JOIN`
- Conditional Filtering
- Aggregate Function `COUNT`

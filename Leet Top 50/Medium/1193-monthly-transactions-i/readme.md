# 1193. Monthly Transactions I

## Problem

Given a `Transactions` table containing transaction records from different countries, generate a monthly report showing:

* Total number of transactions
* Number of approved transactions
* Total transaction amount
* Total approved transaction amount

The report should be grouped by:

* Month (`YYYY-MM`)
* Country

---

## SQL Pattern

**Conditional Aggregation + Date Formatting**

This problem tests the ability to:

* Group records by a derived date value
* Calculate multiple metrics in a single query
* Use conditional aggregation to count and sum specific records

---

## Approach

### Step 1: Extract Month

Convert the transaction date into a monthly format:

```sql
DATE_FORMAT(trans_date, '%Y-%m')
```

Example:

| trans_date | month   |
| ---------- | ------- |
| 2018-12-18 | 2018-12 |
| 2018-12-19 | 2018-12 |
| 2019-01-01 | 2019-01 |

---

### Step 2: Group by Month and Country

```sql
GROUP BY month, country
```

This creates one record for every `(month, country)` combination.

---

### Step 3: Compute Required Metrics

#### Total Transactions

```sql
COUNT(*)
```

Counts all transactions in the group.

---

#### Approved Transactions

```sql
SUM(state = 'approved')
```

In MySQL:

```sql
state = 'approved'
```

evaluates to:

| Result | Value |
| ------ | ----- |
| TRUE   | 1     |
| FALSE  | 0     |

Therefore:

```sql
SUM(state = 'approved')
```

counts approved transactions.

---

#### Total Transaction Amount

```sql
SUM(amount)
```

Adds all transaction amounts.

---

#### Approved Transaction Amount

```sql
SUM(
    CASE
        WHEN state = 'approved' THEN amount
        ELSE 0
    END
)
```

Only approved transactions contribute to the sum.

---

## SQL Solution

```sql
SELECT
    DATE_FORMAT(trans_date, '%Y-%m') AS month,
    country,
    COUNT(*) AS trans_count,
    SUM(state = 'approved') AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(
        CASE
            WHEN state = 'approved' THEN amount
            ELSE 0
        END
    ) AS approved_total_amount
FROM Transactions
GROUP BY month, country;
```

---

## Example Walkthrough

### Input

| id  | country | state    | amount | trans_date |
| --- | ------- | -------- | ------ | ---------- |
| 121 | US      | approved | 1000   | 2018-12-18 |
| 122 | US      | declined | 2000   | 2018-12-19 |
| 123 | US      | approved | 2000   | 2019-01-01 |
| 124 | DE      | approved | 2000   | 2019-01-07 |

---

### Group: (2018-12, US)

Transactions:

| amount | state    |
| ------ | -------- |
| 1000   | approved |
| 2000   | declined |

Calculations:

```text
trans_count = 2
approved_count = 1
trans_total_amount = 3000
approved_total_amount = 1000
```

---

### Group: (2019-01, US)

```text
trans_count = 1
approved_count = 1
trans_total_amount = 2000
approved_total_amount = 2000
```

---

### Group: (2019-01, DE)

```text
trans_count = 1
approved_count = 1
trans_total_amount = 2000
approved_total_amount = 2000
```

---

## Complexity Analysis

### Time Complexity

```text
O(n)
```

Single scan with aggregation.

### Space Complexity

```text
O(k)
```

Where `k` is the number of unique `(month, country)` groups.

---

## Key Takeaways

* Use `DATE_FORMAT()` to aggregate by month.
* Use `GROUP BY` on derived columns.
* Use conditional aggregation for filtered counts and sums.
* `SUM(condition)` is a concise MySQL technique for counting matching rows.
* A common reporting-query pattern in analytics and business intelligence systems.

---

## Related Concepts

* GROUP BY
* Conditional Aggregation
* CASE WHEN
* DATE_FORMAT
* Reporting Queries
* Business Metrics Aggregation

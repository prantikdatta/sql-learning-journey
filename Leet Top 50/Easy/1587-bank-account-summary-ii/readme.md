# 1587. Bank Account Summary II

## Problem

Given the `Users` and `Transactions` tables, report the name and balance of users whose account balance is greater than `10000`.

The balance of an account is calculated as the sum of all transaction amounts associated with that account.

- Positive amounts represent money received.
- Negative amounts represent money transferred out.
- All accounts start with a balance of `0`.

Return the result table in any order.

---

## Schema

### Users

| Column | Type |
|----------|---------|
| account | int |
| name | varchar |

- `account` is the primary key.
- Each account belongs to exactly one user.

### Transactions

| Column | Type |
|----------|---------|
| trans_id | int |
| account | int |
| amount | int |
| transacted_on | date |

- `trans_id` is the primary key.
- `amount > 0` means money received.
- `amount < 0` means money transferred out.

---

## Solution

```sql
SELECT
    u.name,
    SUM(t.amount) AS balance
FROM Users u
LEFT JOIN Transactions t
    ON u.account = t.account
GROUP BY u.account, u.name
HAVING SUM(t.amount) > 10000;
```

---

## Approach

### 1. Join Users and Transactions

We join the two tables using the account number:

```sql
ON u.account = t.account
```

This allows us to access all transactions belonging to each user.

### 2. Calculate Account Balance

The balance is simply:

```sql
SUM(t.amount)
```

Examples:

| Transactions | Balance |
|-------------|----------|
| 7000, 7000, -3000 | 11000 |
| 1000 | 1000 |
| 6000, 6000, -4000 | 8000 |

### 3. Group by User

```sql
GROUP BY u.account, u.name
```

This ensures the balance is computed separately for each account.

### 4. Filter Accounts

Use `HAVING` because the filter depends on an aggregate value:

```sql
HAVING SUM(t.amount) > 10000
```

Only users whose balance exceeds `10000` are returned.

---

## Example Walkthrough

### Alice

```text
7000 + 7000 - 3000 = 11000
```

Included because:

```text
11000 > 10000
```

### Bob

```text
1000
```

Excluded because:

```text
1000 <= 10000
```

### Charlie

```text
6000 + 6000 - 4000 = 8000
```

Excluded because:

```text
8000 <= 10000
```

---

## Complexity Analysis

Let:

- `U` = number of users
- `T` = number of transactions

### Time Complexity

```text
O(T)
```

The database scans transactions and performs aggregation by account.

### Space Complexity

```text
O(U)
```

For storing grouped account balances.

---

## Key SQL Concepts

- `LEFT JOIN`
- `GROUP BY`
- `SUM()`
- `HAVING`
- Aggregate filtering

---

## Alternative Solution (Using Subquery)

```sql
SELECT
    u.name,
    t.balance
FROM Users u
JOIN (
    SELECT
        account,
        SUM(amount) AS balance
    FROM Transactions
    GROUP BY account
    HAVING SUM(amount) > 10000
) t
ON u.account = t.account;
```

Both solutions produce the same result.

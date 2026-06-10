# 550. Game Play Analysis IV

## Problem

The `Activity` table stores player login activity.

Each row contains:

- `player_id`
- `device_id`
- `event_date`
- `games_played`

The task is to find the fraction of players who logged in again on the **day immediately after their first login**.

Return the result as:

- `fraction`

rounded to 2 decimal places.

---

## Approach

### Step 1: Find each player's first login date

For every player, find the minimum `event_date`.

```sql
SELECT
    player_id,
    MIN(event_date) AS first_login
FROM Activity
GROUP BY player_id
```

This gives each player's first login date.

---

### Step 2: Check whether the player logged in the next day

Join the original `Activity` table with the first login result.

Then check if the player has an activity record on:

```sql
DATE_ADD(first_login, INTERVAL 1 DAY)
```

---

### Step 3: Count qualifying players

Count distinct players who logged in exactly one day after their first login.

```sql
COUNT(DISTINCT p.player_id)
```

---

### Step 4: Divide by total players

Divide the qualifying players by the total number of distinct players.

```sql
SELECT COUNT(DISTINCT player_id)
FROM Activity
```

Round the final result to 2 decimal places.

---

## Solution

```sql
SELECT
    ROUND(
        COUNT(DISTINCT p.player_id) /
        (
            SELECT COUNT(DISTINCT player_id)
            FROM Activity
        ),
        2
    ) AS fraction
FROM Activity p
JOIN (
    SELECT
        player_id,
        MIN(event_date) AS first_login
    FROM Activity
    GROUP BY player_id
) a
    ON a.player_id = p.player_id
WHERE p.event_date = DATE_ADD(a.first_login, INTERVAL 1 DAY);
```

---

## Complexity Analysis

### Time Complexity

```text
O(N)
```

The table is scanned to find each player's first login and then checked for next-day login.

### Space Complexity

```text
O(P)
```

where `P` is the number of distinct players.

---

## Key SQL Concepts Used

- Subquery
- `GROUP BY`
- `MIN`
- `COUNT DISTINCT`
- `JOIN`
- Date Function `DATE_ADD`
- `ROUND`

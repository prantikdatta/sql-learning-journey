# 262. Trips and Users

## Problem

Given the `Trips` and `Users` tables, calculate the cancellation rate of taxi requests for each day between `2013-10-01` and `2013-10-03`.

Only trips where both the client and driver are not banned should be considered.

The cancellation rate is calculated as:

```text
cancelled trips / total trips
```

The result should be rounded to two decimal places.

## SQL Pattern

Conditional Aggregation with filtered joins.

## Approach

Join the `Trips` table with the `Users` table twice:

1. Once to check whether the client is banned.
2. Once to check whether the driver is banned.

After filtering out banned users, group the remaining trips by `request_at`.

For each day:

- Count cancelled trips.
- Count total valid trips.
- Divide cancelled trips by total trips.
- Round the result to two decimal places.

Instead of manually dividing counts, we can use `AVG()` on a conditional expression:

```sql
CASE
    WHEN status != 'completed' THEN 1
    ELSE 0
END
```

This returns:

- `1` for cancelled trips
- `0` for completed trips

The average of these values gives the cancellation rate directly.

## SQL Solution

```sql
SELECT
    t.request_at AS Day,
    ROUND(
        AVG(
            CASE
                WHEN t.status != 'completed' THEN 1
                ELSE 0
            END
        ),
        2
    ) AS "Cancellation Rate"
FROM Trips t
JOIN Users c
    ON t.client_id = c.users_id
JOIN Users d
    ON t.driver_id = d.users_id
WHERE c.banned = 'No'
  AND d.banned = 'No'
  AND t.request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY t.request_at
ORDER BY t.request_at;
```

## Example

### Valid Trips After Removing Banned Users

The client with `users_id = 2` is banned, so trips made by that client are ignored.

| id | request_at | status |
|----|------------|---------------------|
| 1 | 2013-10-01 | completed |
| 3 | 2013-10-01 | completed |
| 4 | 2013-10-01 | cancelled_by_client |
| 5 | 2013-10-02 | completed |
| 7 | 2013-10-02 | completed |
| 9 | 2013-10-03 | completed |
| 10 | 2013-10-03 | cancelled_by_driver |

### Daily Calculation

| Day | Cancelled Trips | Total Trips | Cancellation Rate |
|-----|-----------------|-------------|-------------------|
| 2013-10-01 | 1 | 3 | 0.33 |
| 2013-10-02 | 0 | 2 | 0.00 |
| 2013-10-03 | 1 | 2 | 0.50 |

### Output

| Day | Cancellation Rate |
|-----|-------------------|
| 2013-10-01 | 0.33 |
| 2013-10-02 | 0.00 |
| 2013-10-03 | 0.50 |

## Complexity

- Time Complexity: `O(n)`
- Space Complexity: `O(k)`

Where `n` is the number of trips and `k` is the number of grouped days.

## Key Takeaways

- Join the same table multiple times when different foreign keys reference it.
- Filter invalid rows before aggregation.
- Use conditional aggregation to calculate rates.
- `AVG(CASE WHEN ... THEN 1 ELSE 0 END)` is a clean way to calculate ratios.
- Cancellation rate problems are often solved by converting conditions into `1` and `0`.

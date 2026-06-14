# Churn Risk Customers

## Problem

Find users who show warning signs before churning.

A user is considered a **churn risk customer** if they meet all of the following criteria:

- Their current subscription is active
- Their latest event is not `cancel`
- They have performed at least one `downgrade`
- Their current monthly amount is less than `50%` of their historical maximum monthly amount
- They have been a subscriber for at least `60` days

`days_as_subscriber` is calculated from the user's first event date to their latest event date.

## Table Schema

| Column Name    | Type    |
| -------------- | ------- |
| event_id       | int     |
| user_id        | int     |
| event_date     | date    |
| event_type     | varchar |
| plan_name      | varchar |
| monthly_amount | decimal |

## Approach

1. Rank each user's events from latest to earliest using `ROW_NUMBER()`.
2. Aggregate each user's subscription history:
   - first event date
   - latest event date
   - maximum historical monthly amount
   - number of downgrade events
3. Keep only the latest event for each user.
4. Filter users based on churn-risk conditions.
5. Sort by `days_as_subscriber` descending, then `user_id` ascending.

## SQL Solution

```sql
WITH rnk AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY event_date DESC, event_id DESC
        ) AS rn
    FROM subscription_events
),
user_stat AS (
    SELECT
        user_id,
        MAX(event_date) AS latest_date,
        MIN(event_date) AS first_date,
        MAX(monthly_amount) AS max_historical_amount,
        SUM(
            CASE
                WHEN event_type = 'downgrade' THEN 1
                ELSE 0
            END
        ) AS downgrade_count
    FROM subscription_events
    GROUP BY user_id
)
SELECT
    r.user_id,
    r.plan_name AS current_plan,
    r.monthly_amount AS current_monthly_amount,
    u.max_historical_amount,
    DATEDIFF(u.latest_date, u.first_date) AS days_as_subscriber
FROM rnk r
JOIN user_stat u
    ON r.user_id = u.user_id
WHERE r.rn = 1
  AND r.event_type != 'cancel'
  AND u.downgrade_count >= 1
  AND r.monthly_amount < u.max_historical_amount * 0.5
  AND DATEDIFF(u.latest_date, u.first_date) >= 60
ORDER BY
    days_as_subscriber DESC,
    r.user_id ASC;
```

## Explanation

- `ROW_NUMBER()` identifies the latest event for each user.
- `ORDER BY event_date DESC, event_id DESC` handles ties by treating the larger `event_id` as the later event.
- `MAX(monthly_amount)` finds the highest historical subscription revenue for each user.
- `SUM(CASE WHEN event_type = 'downgrade' THEN 1 ELSE 0 END)` counts downgrade events.
- `r.event_type != 'cancel'` ensures the user currently has an active subscription.
- `r.monthly_amount < u.max_historical_amount * 0.5` checks whether current revenue dropped below 50% of the user's historical maximum.
- `DATEDIFF(u.latest_date, u.first_date) >= 60` ensures the user has been a subscriber for at least 60 days.

## Example Output

| user_id | current_plan | current_monthly_amount | max_historical_amount | days_as_subscriber |
| ------- | ------------ | ---------------------- | --------------------- | ------------------ |
| 501     | basic        | 9.99                   | 29.99                 | 79                 |
| 502     | basic        | 9.99                   | 29.99                 | 69                 |

## Complexity Analysis

- Time Complexity: `O(n log n)`
- Space Complexity: `O(n)`

Where:

- `n` = number of rows in `subscription_events`
- Window ranking dominates the sorting cost

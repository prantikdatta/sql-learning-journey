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

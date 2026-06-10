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

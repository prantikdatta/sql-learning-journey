SELECT
    customer_id,
    COUNT(*) AS total_orders,
    ROUND(
        SUM(
            CASE
                WHEN (
                    TIME(order_timestamp) >= '11:00:00'
                    AND TIME(order_timestamp) < '14:00:00'
                )
                OR (
                    TIME(order_timestamp) >= '18:00:00'
                    AND TIME(order_timestamp) < '21:00:00'
                )
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        0
    ) AS peak_hour_percentage,
    ROUND(AVG(order_rating), 2) AS average_rating
FROM restaurant_orders
GROUP BY customer_id
HAVING COUNT(*) >= 3
   AND SUM(
        CASE
            WHEN (
                TIME(order_timestamp) >= '11:00:00'
                AND TIME(order_timestamp) < '14:00:00'
            )
            OR (
                TIME(order_timestamp) >= '18:00:00'
                AND TIME(order_timestamp) < '21:00:00'
            )
            THEN 1
            ELSE 0
        END
   ) * 1.0 / COUNT(*) >= 0.6
   AND AVG(order_rating) >= 4.0
   AND COUNT(order_rating) * 1.0 / COUNT(*) >= 0.5
ORDER BY average_rating DESC, customer_id DESC;

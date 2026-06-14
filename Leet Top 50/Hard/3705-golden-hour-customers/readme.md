# Golden Hour Customers

## Problem

Find customers who consistently order during restaurant peak hours and provide high satisfaction.

A customer is considered a **golden hour customer** if they satisfy all of the following:

- Made at least `3` orders
- At least `60%` of their orders were during peak hours
- Their average rating for rated orders is at least `4.0`
- They rated at least `50%` of their orders

Peak hours are:

- `11:00:00` to before `14:00:00`
- `18:00:00` to before `21:00:00`

## Table Schema

| Column Name     | Type     |
| --------------- | -------- |
| order_id        | int      |
| customer_id     | int      |
| order_timestamp | datetime |
| order_amount    | decimal  |
| payment_method  | varchar  |
| order_rating    | int      |

## Approach

1. Group orders by `customer_id`.
2. Count total orders per customer.
3. Count how many orders happened during peak hours.
4. Calculate the peak-hour order percentage.
5. Calculate the average rating using only rated orders.
6. Check whether at least half of the customer's orders were rated.
7. Filter only customers satisfying all golden-hour conditions.
8. Sort by `average_rating` descending, then `customer_id` descending.

## SQL Solution

```sql
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
```

## Explanation

- `COUNT(*)` calculates total orders for each customer.
- `TIME(order_timestamp)` extracts the time part from the order timestamp.
- The `CASE` expression marks each order as `1` if it occurred during peak hours, otherwise `0`.
- `SUM(CASE ...)` counts peak-hour orders.
- `ROUND(... * 100.0 / COUNT(*), 0)` calculates the peak-hour percentage.
- `AVG(order_rating)` ignores `NULL` values, so it only averages rated orders.
- `COUNT(order_rating)` counts only non-null ratings.
- `COUNT(order_rating) * 1.0 / COUNT(*) >= 0.5` ensures at least 50% of orders were rated.
- `HAVING` is used because all filters are based on aggregate values.

## Example Output

| customer_id | total_orders | peak_hour_percentage | average_rating |
| ----------- | ------------ | -------------------- | -------------- |
| 103         | 3            | 100                  | 4.67           |
| 101         | 4            | 100                  | 4.67           |
| 105         | 3            | 100                  | 4.33           |

## Complexity Analysis

- Time Complexity: `O(n log k)`
- Space Complexity: `O(k)`

Where:

- `n` = number of rows in `restaurant_orders`
- `k` = number of distinct customers
- Sorting the filtered grouped result contributes the `log k` factor

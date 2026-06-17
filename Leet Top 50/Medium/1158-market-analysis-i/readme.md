# 1158. Market Analysis I

## Problem

For each user, report:

- Their `user_id` as `buyer_id`
- Their `join_date`
- The number of orders they made as a buyer in 2019

Users with no orders in 2019 should still appear with `0`.

## Approach

Use a `LEFT JOIN` from `Users` to `Orders`.

The 2019 filter must be placed inside the `JOIN` condition, not the `WHERE` clause. This preserves users who did not make any orders in 2019.

Then count matching `order_id` values for each user.

## SQL Solution

```sql
SELECT
    u.user_id AS buyer_id,
    u.join_date,
    COUNT(o.order_id) AS orders_in_2019
FROM Users u
LEFT JOIN Orders o
    ON u.user_id = o.buyer_id
   AND YEAR(o.order_date) = 2019
GROUP BY u.user_id, u.join_date;
```

## Complexity

- Time Complexity: `O(n + m)`
- Space Complexity: `O(1)`

Where:

- `n` = number of users
- `m` = number of orders

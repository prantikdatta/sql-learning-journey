# 607. Sales Person

## Problem

Find the names of all salespersons who did **not** have any orders related to the company `"RED"`.

## Table Schema

### SalesPerson

| Column Name     | Type    |
| --------------- | ------- |
| sales_id        | int     |
| name            | varchar |
| salary          | int     |
| commission_rate | int     |
| hire_date       | date    |

### Company

| Column Name | Type    |
| ----------- | ------- |
| com_id      | int     |
| name        | varchar |
| city        | varchar |

### Orders

| Column Name | Type |
| ----------- | ---- |
| order_id    | int  |
| order_date  | date |
| com_id      | int  |
| sales_id    | int  |
| amount      | int  |

## Approach

1. Join `Orders` with `Company` to find salespersons who sold to company `"RED"`.
2. Extract their `sales_id`.
3. Return salespersons whose `sales_id` is not in that result.

## SQL Solution

```sql
SELECT
    name
FROM SalesPerson
WHERE sales_id NOT IN (
    SELECT o.sales_id
    FROM Orders o
    JOIN Company c
        ON o.com_id = c.com_id
    WHERE c.name = 'RED'
);
```

## Explanation

- The subquery finds all `sales_id` values associated with orders made to company `"RED"`.
- `NOT IN` removes those salespersons from the final result.
- The outer query returns only the remaining salesperson names.

## Example Output

| name |
| ---- |
| Amy  |
| Mark |
| Alex |

## Complexity Analysis

- Time Complexity: `O(o + c + s)`
- Space Complexity: `O(r)`

Where:

- `o` = number of rows in `Orders`
- `c` = number of rows in `Company`
- `s` = number of rows in `SalesPerson`
- `r` = number of salespersons who sold to `"RED"`

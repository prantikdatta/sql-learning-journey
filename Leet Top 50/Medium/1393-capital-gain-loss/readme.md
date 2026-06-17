# 1393. Capital Gain/Loss

## Problem

Given a `Stocks` table, calculate the total capital gain or loss for each stock.

A `Buy` operation represents money spent, so it is subtracted.  
A `Sell` operation represents money received, so it is added.

## Approach

For each stock:

- Add the price when the operation is `Sell`
- Subtract the price when the operation is `Buy`
- Group by `stock_name`

This works because every valid buy/sell sequence contributes:

```text
Sell price - Buy price

SELECT
    stock_name,
    SUM(
        CASE
            WHEN operation = 'Sell' THEN price
            ELSE -price
        END
    ) AS capital_gain_loss
FROM Stocks
GROUP BY stock_name;

Complexity
Time Complexity: O(n)
Space Complexity: O(k)

Where:

n = number of rows in Stocks
k = number of distinct stocks

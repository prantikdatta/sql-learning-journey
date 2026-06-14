# 511. Game Play Analysis I

## Problem

Find the first login date for each player.

Return each player's ID along with the earliest date they logged into the game.

## Table Schema

| Column Name  | Type |
| ------------ | ---- |
| player_id    | int  |
| device_id    | int  |
| event_date   | date |
| games_played | int  |

### Primary Key

```text
(player_id, event_date)
```

Each row represents a player's activity on a specific date.

## Approach

For each player:

1. Group records by `player_id`.
2. Find the earliest (`MIN`) `event_date`.
3. Return the player ID and the earliest login date.

## SQL Solution

```sql
SELECT
    player_id,
    MIN(event_date) AS first_login
FROM Activity
GROUP BY player_id;
```

## Explanation

- `GROUP BY player_id` creates one group per player.
- `MIN(event_date)` returns the earliest login date within each group.
- The result contains one row per player.

## Example

### Input

| player_id | device_id | event_date | games_played |
| ---------- | ---------- | ---------- | ------------ |
| 1 | 2 | 2016-03-01 | 5 |
| 1 | 2 | 2016-05-02 | 6 |
| 2 | 3 | 2017-06-25 | 1 |
| 3 | 1 | 2016-03-02 | 0 |
| 3 | 4 | 2018-07-03 | 5 |

### Output

| player_id | first_login |
| ---------- | ---------- |
| 1 | 2016-03-01 |
| 2 | 2017-06-25 |
| 3 | 2016-03-02 |

## Complexity Analysis

- Time Complexity: `O(n)`
- Space Complexity: `O(k)`

Where:

- `n` = number of rows in `Activity`
- `k` = number of distinct players

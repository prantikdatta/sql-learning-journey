# 1407. Top Travellers

## Problem

Given two tables, `Users` and `Rides`, report the total distance travelled by each user.

The result should be ordered by:

1. `travelled_distance` in descending order
2. `name` in ascending order when distances are equal

Users who did not take any rides should still appear in the result with a travelled distance of `0`.

## Schema

### Users

| Column | Type |
|---|---|
| id | int |
| name | varchar |

`id` is the primary key.

### Rides

| Column | Type |
|---|---|
| id | int |
| user_id | int |
| distance | int |

`user_id` references the user who travelled the given distance.

## Solution

```sql
SELECT
    u.name AS name,
    COALESCE(SUM(r.distance), 0) AS travelled_distance
FROM Users u
LEFT JOIN Rides r
    ON u.id = r.user_id
GROUP BY u.id, u.name
ORDER BY travelled_distance DESC, u.name ASC;
```

## Explanation

We use a `LEFT JOIN` from `Users` to `Rides` so that every user is included, even users who have no rides.

For each user, we calculate the total distance using:

```sql
SUM(r.distance)
```

If a user has no rides, the sum becomes `NULL`, so we convert it to `0` using:

```sql
COALESCE(SUM(r.distance), 0)
```

Finally, we sort the result by total distance in descending order. If multiple users have the same total distance, we sort them alphabetically by name.

## Complexity

Let:

- `U` be the number of users
- `R` be the number of rides

Time complexity: `O(U + R)`  
Space complexity: `O(U)`

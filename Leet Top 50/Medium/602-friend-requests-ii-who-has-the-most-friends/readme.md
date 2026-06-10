# 602. Friend Requests II: Who Has the Most Friends

## Problem

The `RequestAccepted` table stores accepted friend requests.

Each row contains:

- `requester_id` → user who sent the request
- `accepter_id` → user who accepted the request
- `accept_date` → date when the request was accepted

Friendship is bidirectional.

So if user `1` sends a request to user `2`, then:

- user `1` has user `2` as a friend
- user `2` has user `1` as a friend

Find the user who has the **most friends** and return:

- `id`
- `num` → number of friends

The test cases guarantee that only one user has the maximum number of friends.

---

## Approach

### Step 1: Collect all user IDs from both columns

Since friendship counts for both requester and accepter, combine both columns into one column using `UNION ALL`.

```sql
SELECT requester_id AS id
FROM RequestAccepted

UNION ALL

SELECT accepter_id AS id
FROM RequestAccepted
```

`UNION ALL` is used instead of `UNION` because we need to count every friendship occurrence.

---

### Step 2: Count friends for each user

Group by `id` and count how many times each user appears.

```sql
GROUP BY id
```

Each appearance represents one accepted friendship.

---

### Step 3: Return the user with the highest friend count

Sort by friend count in descending order and return only the top row.

```sql
ORDER BY num DESC
LIMIT 1
```

---

## Solution

```sql
SELECT
    id,
    COUNT(*) AS num
FROM (
    SELECT requester_id AS id
    FROM RequestAccepted

    UNION ALL

    SELECT accepter_id AS id
    FROM RequestAccepted
) t
GROUP BY id
ORDER BY num DESC
LIMIT 1;
```

---

## Follow-up Solution

If multiple people can have the same maximum number of friends, use `DENSE_RANK()`.

```sql
WITH friend_count AS (
    SELECT
        id,
        COUNT(*) AS num
    FROM (
        SELECT requester_id AS id
        FROM RequestAccepted

        UNION ALL

        SELECT accepter_id AS id
        FROM RequestAccepted
    ) t
    GROUP BY id
),
ranked AS (
    SELECT
        id,
        num,
        DENSE_RANK() OVER (ORDER BY num DESC) AS rnk
    FROM friend_count
)

SELECT
    id,
    num
FROM ranked
WHERE rnk = 1;
```

---

## Complexity Analysis

### Time Complexity

```text
O(N log N)
```

Sorting by friend count requires ordering the grouped result.

### Space Complexity

```text
O(N)
```

The derived table stores all requester and accepter IDs.

---

## Key SQL Concepts Used

- `UNION ALL`
- Subquery / Derived Table
- `GROUP BY`
- `COUNT`
- `ORDER BY`
- `LIMIT`
- Window Function for follow-up

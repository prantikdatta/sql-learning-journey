# 608. Tree Node

## Problem

Given a `Tree` table, classify each node as one of the following:

- `Root`: the node has no parent.
- `Inner`: the node has a parent and also has at least one child.
- `Leaf`: the node has a parent but no children.

## SQL Pattern

Tree classification using `CASE` and subquery lookup.

## Approach

Each node can be classified using two conditions:

1. If `p_id IS NULL`, the node is the root.
2. If the node's `id` appears as a `p_id` for another node, it has children.
3. If neither condition is true, the node is a leaf.

The order of the `CASE` conditions matters.

We check for `Root` first because the root may also have children, but it should still be classified as `Root`.

## SQL Solution

```sql
SELECT
    id,
    CASE
        WHEN p_id IS NULL THEN 'Root'
        WHEN id IN (
            SELECT p_id
            FROM Tree
            WHERE p_id IS NOT NULL
        ) THEN 'Inner'
        ELSE 'Leaf'
    END AS type
FROM Tree;
```

## Example

### Tree

| id | p_id |
|----|------|
| 1 | NULL |
| 2 | 1 |
| 3 | 1 |
| 4 | 2 |
| 5 | 2 |

### Classification

Node `1` has no parent, so it is `Root`.

Node `2` has a parent and appears as a parent of nodes `4` and `5`, so it is `Inner`.

Nodes `3`, `4`, and `5` have parents but do not appear as parents of any other node, so they are `Leaf`.

### Output

| id | type |
|----|------|
| 1 | Root |
| 2 | Inner |
| 3 | Leaf |
| 4 | Leaf |
| 5 | Leaf |

## Complexity

- Time Complexity: `O(n)`
- Space Complexity: `O(n)`

Where `n` is the number of rows in `Tree`.

## Key Takeaways

- Use `CASE` when assigning categories based on conditions.
- A root node is identified by `p_id IS NULL`.
- An inner node appears as a parent of another node.
- A leaf node has a parent but no children.
- Check the root condition first to avoid misclassifying the root as an inner node.

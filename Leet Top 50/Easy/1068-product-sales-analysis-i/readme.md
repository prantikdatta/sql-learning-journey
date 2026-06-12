# 1068. Product Sales Analysis I

## Problem

Given two tables:

### Sales

| Column Name | Type |
|------------|------|
| sale_id | int |
| product_id | int |
| year | int |
| quantity | int |
| price | int |

- `(sale_id, year)` is the primary key.
- `product_id` is a foreign key referencing the `Product` table.
- Each row represents a sale of a product in a specific year.
- `price` represents the price per unit.

### Product

| Column Name | Type |
|------------|------|
| product_id | int |
| product_name | varchar |

- `product_id` is the primary key.
- Each row contains the name of a product.

## Objective

Report:

- `product_name`
- `year`
- `price`

for every sale recorded in the `Sales` table.

Return the result in any order.

---

## Approach

The `Sales` table contains the sales information but only stores the `product_id`.

To retrieve the corresponding product name:

1. Join `Sales` with `Product` using `product_id`.
2. Select the required columns:
   - `product_name`
   - `year`
   - `price`

Since every sale belongs to a valid product, an `INNER JOIN` is sufficient.

---

## SQL Solution

```sql
SELECT
    p.product_name,
    s.year,
    s.price
FROM Sales s
JOIN Product p
    ON s.product_id = p.product_id;
```

---

## Explanation

### Join Condition

```sql
s.product_id = p.product_id
```

This matches each sale with its product information.

### Selected Columns

```sql
p.product_name
```

Returns the product name.

```sql
s.year
```

Returns the year of the sale.

```sql
s.price
```

Returns the price of the product during that sale.

---

## Example

### Input

#### Sales

| sale_id | product_id | year | quantity | price |
|----------|------------|------|----------|--------|
| 1 | 100 | 2008 | 10 | 5000 |
| 2 | 100 | 2009 | 12 | 5000 |
| 7 | 200 | 2011 | 15 | 9000 |

#### Product

| product_id | product_name |
|------------|-------------|
| 100 | Nokia |
| 200 | Apple |
| 300 | Samsung |

### Output

| product_name | year | price |
|--------------|------|--------|
| Nokia | 2008 | 5000 |
| Nokia | 2009 | 5000 |
| Apple | 2011 | 9000 |

---

## Complexity Analysis

Let:

- `S` = number of rows in `Sales`
- `P` = number of rows in `Product`

### Time Complexity

```text
O(S)
```

Each sale row is matched with its corresponding product through the primary key.

### Space Complexity

```text
O(1)
```

No additional data structures are used apart from the result set.

---

## Key SQL Concepts

- INNER JOIN
- Foreign Key Relationships
- Column Selection
- Relational Data Retrieval

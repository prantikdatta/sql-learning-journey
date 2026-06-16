# 3575. Find Products with Valid Serial Numbers

## Problem

Given a `products` table containing product information, find all products whose description contains a valid serial number.

A valid serial number:

1. Starts with `SN` (case-sensitive).
2. Is followed by exactly 4 digits.
3. Contains a hyphen `-`.
4. Ends with exactly 4 digits.
5. Can appear anywhere within the description.
6. Must not be part of a larger alphanumeric string.

Return the result ordered by `product_id` in ascending order.

---

## Table Schema

```sql
products(
    product_id INT,
    product_name VARCHAR,
    description VARCHAR
)
```

---

## Approach

Since the serial number may appear anywhere inside the description, regular expressions provide a convenient way to validate the pattern.

The required format is:

```text
SNdddd-dddd
```

where `d` represents a digit.

The regex used is:

```text
(^|[^A-Za-z0-9])SN[0-9]{4}-[0-9]{4}([^A-Za-z0-9]|$)
```

### Breakdown

- `(^|[^A-Za-z0-9])`
  - Beginning of string or a non-alphanumeric character before the serial number.

- `SN`
  - Must start with uppercase `SN`.

- `[0-9]{4}`
  - Exactly four digits.

- `-`
  - Hyphen separator.

- `[0-9]{4}`
  - Exactly four digits after the hyphen.

- `([^A-Za-z0-9]|$)`
  - Ensures the serial number is not immediately followed by another letter or digit.

The `'c'` option in `REGEXP_LIKE` enforces case-sensitive matching.

---

## Solution

```sql
SELECT *
FROM products
WHERE REGEXP_LIKE(
    description,
    '(^|[^A-Za-z0-9])SN[0-9]{4}-[0-9]{4}([^A-Za-z0-9]|$)',
    'c'
)
ORDER BY product_id;
```

---

## Example

Input:

| product_id | description |
|------------:|-------------|
| 1 | This is a sample product with SN1234-5678 |
| 2 | A product with serial SN9876-1234 in the description |
| 3 | Product SN1234-56789 is available now |
| 4 | No serial number here |
| 5 | Check out SN4321-8765 in this description |

Output:

| product_id |
|------------:|
| 1 |
| 2 |
| 5 |

---

## Complexity Analysis

Let `n` be the number of rows.

- **Time Complexity:** `O(n)`
- **Space Complexity:** `O(1)` extra space

---

## Key Concept

This problem is an application of **regular expression pattern matching** using MySQL's `REGEXP_LIKE()` function to locate and validate structured substrings within text fields.

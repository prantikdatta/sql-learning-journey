# 3574. Find Valid Email Addresses

## Problem

Given a `Users` table containing user IDs and email addresses, find all valid email addresses.

A valid email address must satisfy the following conditions:

1. Contains exactly one `@` symbol.
2. Ends with `.com`.
3. The part before `@` contains only:
   - Uppercase letters (`A-Z`)
   - Lowercase letters (`a-z`)
   - Digits (`0-9`)
   - Underscores (`_`)
4. The domain name (between `@` and `.com`) contains only letters.

Return the result ordered by `user_id` in ascending order.

---

## Table Schema

```sql
Users(
    user_id INT,
    email VARCHAR
)
```

---

## Approach

Since email validation follows a specific pattern, we can use a regular expression to filter valid addresses.

The required format is:

```text
username@domain.com
```

where:

- `username` consists of letters, digits, and underscores.
- `domain` consists only of letters.
- The email ends with `.com`.

---

## Regex Breakdown

```text
^[A-Za-z0-9_]+@[A-Za-z]+\.com$
```

### `^`
Ensures matching starts from the beginning of the string.

### `[A-Za-z0-9_]+`
Matches one or more:

- Uppercase letters
- Lowercase letters
- Digits
- Underscores

This represents the username before `@`.

### `@`
Matches exactly one `@` symbol.

### `[A-Za-z]+`
Matches one or more letters for the domain name.

### `\.com`
Ensures the email ends with `.com`.

### `$`
Ensures matching ends at the end of the string.

---

## Solution

```sql
SELECT *
FROM Users
WHERE email REGEXP '^[A-Za-z0-9_]+@[A-Za-z]+\\.com$'
ORDER BY user_id;
```

---

## Example

Input:

| user_id | email |
|---------:|-------|
| 1 | alice@example.com |
| 2 | bob_at_example.com |
| 3 | charlie@example.net |
| 4 | david@domain.com |
| 5 | eve@invalid |

Output:

| user_id | email |
|---------:|------|
| 1 | alice@example.com |
| 4 | david@domain.com |

---

## Complexity Analysis

Let **n** be the number of rows.

- **Time Complexity:** `O(n)`
- **Space Complexity:** `O(1)` extra space

---

## Key Concept

This problem demonstrates how **regular expressions** can be used in SQL to validate text patterns efficiently. By enforcing the structure:

```text
username@domain.com
```

we can identify all valid email addresses with a single `REGEXP` condition.

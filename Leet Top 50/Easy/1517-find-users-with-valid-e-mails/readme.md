# 1517. Find Users With Valid E-mails

## Problem

Given a table:

### Users

| Column Name | Type |
|------------|------|
| user_id | int |
| name | varchar |
| mail | varchar |

- `user_id` is the primary key.
- The table contains user information and email addresses.
- Some email addresses may be invalid.

## Objective

Return all users whose email addresses are valid.

A valid email must satisfy:

### Prefix Rules

The part before `@leetcode.com`:

- Must start with a letter (`A-Z` or `a-z`)
- Can contain:
  - letters
  - digits
  - underscore `_`
  - period `.`
  - dash `-`

### Domain Rule

The email must end with:

```text
@leetcode.com
```

Return the result in any order.

---

## Approach

This problem is a perfect use case for a regular expression.

We need to validate:

```text
prefix@leetcode.com
```

where:

- the first character of the prefix is a letter
- remaining characters may contain letters, digits, `.`, `_`, or `-`
- domain must exactly match `@leetcode.com`

---

## SQL Solution

```sql
SELECT *
FROM Users
WHERE mail COLLATE utf8mb3_bin
REGEXP '^[A-Za-z][A-Za-z0-9._-]*@leetcode\\.com$';
```

---

## Regex Breakdown

### Full Pattern

```regex
^[A-Za-z][A-Za-z0-9._-]*@leetcode\.com$
```

### Start of String

```regex
^
```

Ensures matching begins from the start of the email.

---

### First Character Must Be a Letter

```regex
[A-Za-z]
```

Examples:

✅ Valid

```text
a
Z
bella
```

❌ Invalid

```text
1bella
.bella
_bella
-bella
```

---

### Remaining Prefix Characters

```regex
[A-Za-z0-9._-]*
```

Allows zero or more of:

- letters
- numbers
- `.`
- `_`
- `-`

Examples:

✅ Valid

```text
bella-
john_123
sally.come
David69
```

❌ Invalid

```text
quarz#2020
john$
bella!
```

because `#`, `$`, and `!` are not allowed.

---

### Required Domain

```regex
@leetcode\.com
```

The domain must exactly be:

```text
@leetcode.com
```

The period is escaped:

```regex
\.
```

because `.` is a special regex character.

---

### End of String

```regex
$
```

Ensures nothing appears after:

```text
@leetcode.com
```

---

## Why Use COLLATE utf8mb3_bin?

```sql
mail COLLATE utf8mb3_bin
```

Forces binary comparison.

This makes regex matching case-sensitive and prevents collation-specific behavior that may affect pattern matching.

Although the solution often passes without it, using binary collation makes the regex evaluation deterministic.

---

## Example Walkthrough

### Valid

```text
winston@leetcode.com
```

- starts with letter ✅
- valid characters only ✅
- correct domain ✅

---

### Valid

```text
bella-@leetcode.com
```

- starts with letter ✅
- dash allowed ✅
- correct domain ✅

---

### Valid

```text
sally.come@leetcode.com
```

- starts with letter ✅
- period allowed ✅
- correct domain ✅

---

### Invalid

```text
jonathanisgreat
```

- missing domain ❌

---

### Invalid

```text
quarz#2020@leetcode.com
```

- contains `#` ❌

---

### Invalid

```text
david69@gmail.com
```

- wrong domain ❌

---

### Invalid

```text
.shapo@leetcode.com
```

- starts with `.` ❌

---

## Complexity Analysis

Let:

- `n` = number of users
- `m` = average email length

### Time Complexity

```text
O(n × m)
```

Each email is checked against the regex pattern.

### Space Complexity

```text
O(1)
```

No additional storage is used.

---

## Key SQL Concepts

- REGEXP
- Pattern Matching
- Character Classes
- Anchors (`^` and `$`)
- Escaping Special Characters
- String Validation
- Binary Collation

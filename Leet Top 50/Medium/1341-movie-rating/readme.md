# 1341. Movie Rating

## Problem

Given the `Movies`, `Users`, and `MovieRating` tables, return two results:

1. The user who rated the greatest number of movies.
2. The movie with the highest average rating in February 2020.

If there is a tie:

- Return the lexicographically smaller user name.
- Return the lexicographically smaller movie title.

## SQL Pattern

Aggregation with tie-breaking and `UNION ALL`.

## Approach

This problem has two independent parts.

### Part 1: User with the Most Ratings

Join `Users` with `MovieRating`.

Group by each user and count how many movies they rated.

Sort by:

1. Rating count in descending order
2. User name in ascending lexicographical order

The first row is the required user.

### Part 2: Highest Rated Movie in February 2020

Join `Movies` with `MovieRating`.

Filter reviews created in February 2020.

Group by each movie and calculate the average rating.

Sort by:

1. Average rating in descending order
2. Movie title in ascending lexicographical order

The first row is the required movie.

Finally, combine both results using `UNION ALL`.

## SQL Solution

```sql
(
    SELECT u.name AS results
    FROM Users u
    JOIN MovieRating mr
        ON u.user_id = mr.user_id
    GROUP BY u.user_id, u.name
    ORDER BY COUNT(*) DESC, u.name
    LIMIT 1
)
UNION ALL
(
    SELECT m.title AS results
    FROM Movies m
    JOIN MovieRating mr
        ON m.movie_id = mr.movie_id
    WHERE DATE_FORMAT(mr.created_at, '%Y-%m') = '2020-02'
    GROUP BY m.movie_id, m.title
    ORDER BY AVG(mr.rating) DESC, m.title
    LIMIT 1
);
```

## Example

### Users

| user_id | name |
|---------|--------|
| 1 | Daniel |
| 2 | Monica |
| 3 | Maria |
| 4 | James |

### Movies

| movie_id | title |
|----------|----------|
| 1 | Avengers |
| 2 | Frozen 2 |
| 3 | Joker |

### MovieRating

| movie_id | user_id | rating | created_at |
|----------|---------|--------|------------|
| 1 | 1 | 3 | 2020-01-12 |
| 1 | 2 | 4 | 2020-02-11 |
| 1 | 3 | 2 | 2020-02-12 |
| 1 | 4 | 1 | 2020-01-01 |
| 2 | 1 | 5 | 2020-02-17 |
| 2 | 2 | 2 | 2020-02-01 |
| 2 | 3 | 2 | 2020-03-01 |
| 3 | 1 | 3 | 2020-02-22 |
| 3 | 2 | 4 | 2020-02-25 |

### User Rating Counts

| name | rating_count |
|------|--------------|
| Daniel | 3 |
| Monica | 3 |
| Maria | 2 |
| James | 1 |

Daniel and Monica both rated 3 movies. Daniel is returned because it is lexicographically smaller.

### February 2020 Movie Average Ratings

| title | average_rating |
|-------|----------------|
| Frozen 2 | 3.5 |
| Joker | 3.5 |
| Avengers | 3.0 |

Frozen 2 and Joker both have an average rating of 3.5. Frozen 2 is returned because it is lexicographically smaller.

### Output

| results |
|---------|
| Daniel |
| Frozen 2 |

## Complexity

- Time Complexity: `O(n log n)`
- Space Complexity: `O(k)`

Where `n` is the number of rows in `MovieRating`, and `k` is the number of grouped users or movies.

## Key Takeaways

- Use `GROUP BY` with aggregate functions for ranking grouped data.
- Use `ORDER BY aggregate DESC, name ASC` to handle tie-breaking.
- Use `UNION ALL` when combining two independent single-row results.
- Use `DATE_FORMAT()` to filter records by year and month.
- This is a common pattern for leaderboard and reporting-style SQL questions.

SELECT id, visit_date, people
FROM (
    SELECT *,
           id - DENSE_RANK() OVER (ORDER BY id) AS grp
    FROM Stadium
    WHERE people >= 100
) t
WHERE grp IN (
    SELECT grp
    FROM (
        SELECT id - DENSE_RANK() OVER (ORDER BY id) AS grp
        FROM Stadium
        WHERE people >= 100
    ) x
    GROUP BY grp
    HAVING COUNT(*) >= 3
)
ORDER BY visit_date;

WITH ranked_scores AS (
    SELECT
        student_id,
        subject,
        score,
        exam_date,
        ROW_NUMBER() OVER (
            PARTITION BY student_id, subject
            ORDER BY exam_date
        ) AS first_rank,
        ROW_NUMBER() OVER (
            PARTITION BY student_id, subject
            ORDER BY exam_date DESC
        ) AS latest_rank
    FROM Scores
),
first_latest_scores AS (
    SELECT
        student_id,
        subject,
        MAX(CASE WHEN first_rank = 1 THEN score END) AS first_score,
        MAX(CASE WHEN latest_rank = 1 THEN score END) AS latest_score,
        COUNT(*) AS exam_count
    FROM ranked_scores
    GROUP BY student_id, subject
)
SELECT
    student_id,
    subject,
    first_score,
    latest_score
FROM first_latest_scores
WHERE exam_count >= 2
  AND latest_score > first_score
ORDER BY student_id, subject;

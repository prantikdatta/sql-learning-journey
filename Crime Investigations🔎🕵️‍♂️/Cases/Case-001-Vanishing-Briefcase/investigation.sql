/* CASE #001 - THE VANISHING BRIEFCASE */

SELECT *
FROM crime_scene
WHERE location = 'Blue Note Lounge';

SELECT *
FROM suspects
WHERE attire = 'trench coat'
  AND scar = 'left cheek';

SELECT
    suspect_id,
    name,
    transcript
FROM interviews
JOIN suspects
    ON interviews.suspect_id = suspects.id
WHERE attire = 'trench coat'
  AND scar = 'left cheek'
  AND transcript IS NOT NULL;

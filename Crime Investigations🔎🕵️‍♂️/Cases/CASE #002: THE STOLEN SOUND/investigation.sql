/* ============================================================
   CASE #002: THE STOLEN SOUND
   Objective: Identify who stole the valuable vinyl record
   ============================================================ */

-- Step 1: Review the crime scene report
SELECT
    id,
    description
FROM crime_scene
WHERE location = 'West Hollywood Records';

-- Logic:
-- Confirms that the stolen item was a prized vinyl record.


-- Step 2: Collect witness clues
SELECT
    w.clue
FROM witnesses w
JOIN crime_scene cs
    ON w.crime_scene_id = cs.id
WHERE cs.location = 'West Hollywood Records';

-- Logic:
-- Witnesses remembered two clues:
-- 1. Red bandana
-- 2. Gold watch


-- Step 3: Find suspects matching both clues
SELECT
    id,
    name
FROM suspects
WHERE bandana_color = 'red'
  AND accessory = 'gold watch';

-- Logic:
-- Only suspects matching both witness details should be investigated further.


-- Step 4: Review interviews of matching suspects
SELECT
    i.suspect_id,
    s.name,
    i.transcript
FROM interviews i
JOIN suspects s
    ON i.suspect_id = s.id
WHERE s.bandana_color = 'red'
  AND s.accessory = 'gold watch'
  AND i.transcript IS NOT NULL;

-- Logic:
-- The guilty suspect should either confess or reveal inconsistency.

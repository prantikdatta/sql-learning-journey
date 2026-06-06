/* ============================================================
   CASE #003: THE MIAMI MARINA MURDER
   Objective: Identify the murderer at Coral Bay Marina
   ============================================================ */

-- Step 1: Review the crime scene report
SELECT
    description
FROM crime_scene
WHERE location = 'Coral Bay Marina'
  AND date = 19860814;

-- Logic:
-- The report mentions two nearby people:
-- 1. Someone living on 300ish Ocean Drive
-- 2. Someone whose name pattern ends with "ul" and "ez"


-- Step 2: Identify person living on Ocean Drive
SELECT *
FROM person
WHERE address LIKE '%Ocean Drive';

-- Logic:
-- This identifies the witness connected to the Ocean Drive clue.


-- Step 3: Identify person matching name clue
SELECT *
FROM person
WHERE name LIKE '%ul%'
  AND name LIKE '%ez%';

-- Logic:
-- This identifies the second witness based on partial name memory.


-- Step 4: Review interviews from both identified people
SELECT *
FROM interviews
WHERE person_id IN (101, 102);

-- Logic:
-- Witness interviews provide the next lead:
-- a nervous hotel guest checked in on August 13
-- at a hotel with "Sunset" in the name.


-- Step 5: Search hotel check-ins matching the lead
SELECT *
FROM hotel_checkins
WHERE check_in_date = 19860813
  AND hotel_name LIKE '%Sunset%';

-- Logic:
-- This narrows the investigation to hotel guests matching the witness account.


-- Step 6: Check surveillance linked to matching hotel check-ins
SELECT
    sr.person_id,
    sr.suspicious_activity
FROM hotel_checkins hc
JOIN surveillance_records sr
    ON hc.id = sr.hotel_checkin_id
WHERE hc.check_in_date = 19860813
  AND hc.hotel_name LIKE '%Sunset%'
  AND sr.suspicious_activity IS NOT NULL;

-- Logic:
-- Suspicious activity identifies the likely murderer.


-- Step 7: Check confession record
SELECT
    confession
FROM confessions
WHERE person_id = 8;

-- Logic:
-- A confession confirms the suspect's involvement.


-- Step 8: Confirm the suspect's identity
SELECT
    name
FROM person
WHERE id = 8;

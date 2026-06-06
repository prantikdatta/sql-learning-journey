-- ============================================================
-- CASE #001: THE VANISHING BRIEFCASE
-- ============================================================
---------------------------------------------------------------

-- BACKGROUND
-- Date: November 20, 1985
-- Location: Blue Note Lounge
-----------------------------

-- A briefcase containing sensitive documents vanished from the
-- Blue Note Lounge. A witness reported seeing a man wearing a
-- trench coat with a scar on his left cheek fleeing the scene.
---------------------------------------------------------------

-- OBJECTIVE
-- Identify the suspect responsible for the theft.
--------------------------------------------------

-- ============================================================
-- STEP 1: REVIEW THE CRIME SCENE REPORT
-- ============================================================

SELECT *
FROM crime_scene
WHERE location = 'Blue Note Lounge';

-- Findings:
-- A witness observed a man wearing:
--   • A trench coat
--   • A scar on his left cheek

-- ============================================================
-- STEP 2: IDENTIFY MATCHING SUSPECTS
-- ============================================================

SELECT *
FROM suspects
WHERE attire = 'trench coat'
AND scar = 'left cheek';

-- Potential Suspects:
--   1. Frankie Lombardi
--   2. Vincent Malone

-- ============================================================
-- STEP 3: ANALYZE SUSPECT INTERVIEWS
-- ============================================================

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

## -- Evidence Collected:

-- Vincent Malone:
-- "I wasn't going to steal it, but I did."
-------------------------------------------

-- The statement serves as a direct confession to the crime.

-- ============================================================
-- CASE CONCLUSION
-- ============================================================
---------------------------------------------------------------

## -- Culprit: Vincent Malone

-- Verdict:
-- Based on witness testimony, suspect profiling, and the
-- recorded confession, Vincent Malone is confirmed as the
-- individual responsible for stealing the briefcase from the
-- Blue Note Lounge.
--------------------

-- CASE STATUS: SOLVED ✓
-- ============================================================

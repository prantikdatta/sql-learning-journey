/* ============================================================
   CASE #004: THE MIDNIGHT MASQUERADE MURDER
   Objective: Identify who killed Leonard Pierce
   ============================================================ */

-- Step 1: Confirm the victim's identity
SELECT *
FROM person
WHERE name = 'Leonard Pierce';

-- Logic:
-- Confirms Leonard Pierce as the victim.


-- Step 2: Review the crime scene report
SELECT
    id,
    description
FROM crime_scene
WHERE date = 19871031
  AND location LIKE '%Coconut Grove%';

-- Logic:
-- The report mentions:
-- 1. A hotel booking
-- 2. Room 707
-- 3. Suspicious phone activity


-- Step 3: Review witness statements from the crime scene
SELECT
    witness_id,
    clue
FROM witness_statements
WHERE crime_scene_id = 75;

-- Logic:
-- Witnesses point toward The Grand Regency and Room 707.


-- Step 4: Investigate hotel check-in and surveillance records
SELECT
    hc.person_id,
    sr.note
FROM hotel_checkins hc
JOIN surveillance_records sr
    ON hc.id = sr.hotel_checkin_id
WHERE hc.hotel_name = 'The Grand Regency'
  AND hc.room_number = 707
  AND hc.check_in_date = 19871030;

-- Logic:
-- Person ID 11 was overheard asking:
-- "Did you kill him?"


-- Step 5: Review phone records involving person ID 11
SELECT
    caller_id,
    recipient_id,
    call_date,
    call_time,
    note
FROM phone_records
WHERE caller_id = 11
   OR recipient_id = 11;

-- Logic:
-- The call reveals that person ID 58 was involved,
-- but also mentions a carpenter.


-- Step 6: Review phone records involving person ID 58
SELECT
    caller_id,
    recipient_id,
    call_date,
    call_time,
    note
FROM phone_records
WHERE caller_id = 58
   OR recipient_id = 58;

-- Logic:
-- The call mentions a Lamborghini as payment.


-- Step 7: Find a carpenter connected to a Lamborghini
SELECT
    vr.person_id,
    p.name
FROM vehicle_registry vr
JOIN person p
    ON vr.person_id = p.id
WHERE vr.car_make = 'Lamborghini'
  AND p.occupation = 'Carpenter';

-- Logic:
-- This identifies Marco Santos as the carpenter connected to the Lamborghini clue.


-- Step 8: Review final interview
SELECT *
FROM final_interviews
WHERE person_id = 97;

-- Logic:
-- The final interview confirms whether Marco Santos ordered the hit.

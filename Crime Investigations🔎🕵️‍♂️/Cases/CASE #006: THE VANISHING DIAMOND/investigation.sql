/* ============================================================
   CASE #006: THE VANISHING DIAMOND
   Objective: Identify who stole the Heart of Atlantis necklace
   ============================================================ */

-- Step 1: Review the crime scene report
SELECT id, description 
FROM crime_scene 
WHERE location LIKE '%Fontainebleau Hotel%';

-- Logic:
-- Confirms the theft of the Heart of Atlantis necklace at the Fontainebleau Hotel.
-- It notes that many guests were questioned but only two gave valuable clues.


-- Step 2: Review witness statements from the crime scene
SELECT witness_id, clue 
FROM witness_statements 
WHERE crime_scene_id = 6; -- Note: Replace with actual crime_scene_id if different

-- Logic:
-- Clint Eastwood (Actor) overheard: "Meet me at the marina, dock 3."
-- Vivian Nair (Consultant) saw: Someone holding an invitation ending with "-R", wearing a navy suit and a white tie.


-- Step 3: Filter guests based on attire and invitation clues
SELECT g.id, g.name, g.invitation_code, a.note 
FROM guest g
JOIN attire_registry a 
    ON g.id = a.guest_id
WHERE g.invitation_code LIKE '%R'
  AND a.note LIKE '%navy suit%'
  AND a.note LIKE '%white tie%';

-- Logic:
-- Narrows down the suspect list to male guests wearing a navy suit and white tie whose invitation codes end with the letter 'R'.


-- Step 4: Cross-reference suspects with the marina rentals
SELECT renter_guest_id, boat_name, dock_number 
FROM marina_rentals
WHERE dock_number = 3;

-- Logic:
-- Verifies Clint Eastwood's clue by identifying who rented a boat at dock 3.
-- Combining Step 3 and Step 4 pinpoints Guest ID 105 (Mike Manning).


-- Step 5: Review final interview and confession
SELECT g.name, f.confession 
FROM guest g
JOIN final_interviews f 
    ON g.id = f.guest_id
WHERE g.id = 105;

-- Logic:
-- The final interview confirms whether Mike Manning is the thief.

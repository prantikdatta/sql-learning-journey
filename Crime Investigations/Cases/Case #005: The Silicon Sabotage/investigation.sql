/*
Case #005: The Silicon Sabotage
Objective: Find who sabotaged the QuantaX microprocessor.
Dialect: SQLite / SQL.js

Final finding: Hristo Bogoev

How to use:
1. Open Case #005 in SQLNoir.
2. Run each numbered section in order.
3. Use the comments after each query to compare expected outputs.
*/

-- 00. Inspect available tables.
SELECT
    name AS table_name
FROM sqlite_master
WHERE type = 'table'
ORDER BY name;


-- 01. Locate the target incident report.
-- Goal: identify the exact incident_id and event date.
SELECT
    id AS incident_id,
    date AS incident_date,
    location,
    description
FROM incident_reports
WHERE location = 'QuantumTech HQ'
   OR description LIKE '%Prototype destroyed%'
   OR description LIKE '%data erased%';

-- Expected key result:
-- incident_id = 74
-- incident_date = 19890421
-- location = QuantumTech HQ


-- 02. Pull witness statements connected to the QuantumTech incident.
-- Goal: convert the incident report into actionable clues.
WITH target_incident AS (
    SELECT id, date
    FROM incident_reports
    WHERE location = 'QuantumTech HQ'
)
SELECT
    w.id AS witness_statement_id,
    e.id AS witness_employee_id,
    e.employee_name AS witness_name,
    e.department,
    e.occupation,
    w.statement
FROM witness_statements AS w
JOIN employee_records AS e
    ON e.id = w.employee_id
WHERE w.incident_id = (SELECT id FROM target_incident)
ORDER BY w.id;

-- Expected clue witnesses:
-- Carl Jenkins: mentions a server in Helsinki.
-- Tina Ruiz: saw a keycard marked QX- followed by an odd two-digit number.


-- 03. Investigate Tina Ruiz's keycard clue.
-- Goal: find employees with QX keycards whose final two digits form an odd number.
-- This clue alone is too broad, so do not stop here.
WITH target_incident AS (
    SELECT date
    FROM incident_reports
    WHERE location = 'QuantumTech HQ'
)
SELECT
    k.id AS keycard_log_id,
    e.id AS employee_id,
    e.employee_name,
    e.department,
    e.occupation,
    k.keycard_code,
    k.access_date,
    k.access_time
FROM keycard_access_logs AS k
JOIN employee_records AS e
    ON e.id = k.employee_id
WHERE k.access_date = (SELECT date FROM target_incident)
  AND k.keycard_code LIKE 'QX-%'
  AND CAST(substr(k.keycard_code, -2) AS INTEGER) % 2 = 1
ORDER BY k.access_time;

-- Expected: many records. This creates a suspect pool, not the culprit.


-- 04. Investigate Carl Jenkins's Helsinki server clue.
-- Goal: find employees with Helsinki server activity on the incident date.
-- This clue alone is also too broad.
WITH target_incident AS (
    SELECT date
    FROM incident_reports
    WHERE location = 'QuantumTech HQ'
)
SELECT
    c.id AS computer_log_id,
    e.id AS employee_id,
    e.employee_name,
    e.department,
    e.occupation,
    c.server_location,
    c.access_date,
    c.access_time
FROM computer_access_logs AS c
JOIN employee_records AS e
    ON e.id = c.employee_id
WHERE c.access_date = (SELECT date FROM target_incident)
  AND c.server_location = 'Helsinki'
ORDER BY c.access_time;

-- Expected: multiple records. Still too broad.


-- 05. Intersect both independent clues.
-- Goal: find the person who matches BOTH Tina's keycard clue and Carl's Helsinki server clue.
WITH target_incident AS (
    SELECT date
    FROM incident_reports
    WHERE location = 'QuantumTech HQ'
),
odd_qx_keycards AS (
    SELECT *
    FROM keycard_access_logs
    WHERE access_date = (SELECT date FROM target_incident)
      AND keycard_code LIKE 'QX-%'
      AND CAST(substr(keycard_code, -2) AS INTEGER) % 2 = 1
),
helsinki_access AS (
    SELECT *
    FROM computer_access_logs
    WHERE access_date = (SELECT date FROM target_incident)
      AND server_location = 'Helsinki'
)
SELECT DISTINCT
    e.id AS employee_id,
    e.employee_name,
    e.department,
    e.occupation,
    k.keycard_code,
    k.access_time AS keycard_access_time,
    c.server_location,
    c.access_time AS server_access_time
FROM odd_qx_keycards AS k
JOIN helsinki_access AS c
    ON c.employee_id = k.employee_id
   AND c.access_date = k.access_date
JOIN employee_records AS e
    ON e.id = k.employee_id
ORDER BY e.employee_name;

-- Expected key result:
-- employee_id = 99
-- employee_name = Elizabeth Gordon
-- keycard_code = QX-035
-- server_location = Helsinki


-- 06. Review Elizabeth Gordon's own witness statement.
-- Goal: understand why Elizabeth appears in both suspicious logs.
WITH elizabeth AS (
    SELECT id
    FROM employee_records
    WHERE employee_name = 'Elizabeth Gordon'
      AND department = 'Engineering'
      AND occupation = 'Solutions Architect'
)
SELECT
    w.id AS witness_statement_id,
    e.id AS employee_id,
    e.employee_name,
    w.statement
FROM witness_statements AS w
JOIN employee_records AS e
    ON e.id = w.employee_id
WHERE w.employee_id = (SELECT id FROM elizabeth);

-- Expected clue:
-- Elizabeth says she received an email warning about a possible alarm issue near the chip.


-- 07. Find the email that caused Elizabeth to go to the chip/facility area.
-- Goal: identify who manipulated Elizabeth's movement.
WITH elizabeth AS (
    SELECT id
    FROM employee_records
    WHERE employee_name = 'Elizabeth Gordon'
      AND department = 'Engineering'
      AND occupation = 'Solutions Architect'
)
SELECT
    em.id AS email_id,
    sender.id AS sender_employee_id,
    sender.employee_name AS sender_name,
    recipient.id AS recipient_employee_id,
    recipient.employee_name AS recipient_name,
    em.email_date,
    em.email_subject,
    em.email_content
FROM email_logs AS em
LEFT JOIN employee_records AS sender
    ON sender.id = em.sender_employee_id
JOIN employee_records AS recipient
    ON recipient.id = em.recipient_employee_id
WHERE em.recipient_employee_id = (SELECT id FROM elizabeth)
  AND em.email_date = 19890421
ORDER BY em.id;

-- Expected key result:
-- sender_employee_id = 263
-- sender_name = Norman Owens
-- subject = Alarm System Concern


-- 08. Check Norman Owens's incoming emails from unknown senders.
-- Goal: see whether Norman acted alone or was instructed by someone else.
WITH norman AS (
    SELECT sender_employee_id AS id
    FROM email_logs
    WHERE recipient_employee_id = (
        SELECT id
        FROM employee_records
        WHERE employee_name = 'Elizabeth Gordon'
          AND department = 'Engineering'
          AND occupation = 'Solutions Architect'
    )
      AND email_subject = 'Alarm System Concern'
)
SELECT
    em.id AS email_id,
    em.sender_employee_id,
    em.recipient_employee_id,
    recipient.employee_name AS recipient_name,
    em.email_date,
    em.email_subject,
    em.email_content
FROM email_logs AS em
JOIN employee_records AS recipient
    ON recipient.id = em.recipient_employee_id
WHERE em.recipient_employee_id = (SELECT id FROM norman)
  AND em.sender_employee_id IS NULL
  AND em.email_date = 19890421
ORDER BY em.id;

-- Expected clues:
-- 1. Realign Asset Trajectory: send L into Facility 18 before 9.
-- 2. Execute Phase Window: unlock Facility 18 by 9; "He" will use his own credentials shortly after L leaves.


-- 09. Review all Facility 18 access on the incident date.
-- Goal: place Elizabeth and the real saboteur on the facility timeline.
SELECT
    f.id AS facility_log_id,
    e.id AS employee_id,
    e.employee_name,
    e.department,
    e.occupation,
    f.facility_name,
    f.access_date,
    f.access_time
FROM facility_access_logs AS f
JOIN employee_records AS e
    ON e.id = f.employee_id
WHERE f.facility_name = 'Facility 18'
  AND f.access_date = 19890421
ORDER BY f.access_time;

-- Important timeline:
-- 08:55 | Elizabeth Gordon enters Facility 18.
-- 09:01 | Hristo Bogoev enters Facility 18.
-- Later entries are outside the suspicious phase window described in the anonymous email.


-- 10. Final suspect query.
-- Goal: identify the person who entered Facility 18 shortly after the 09:00 unlock instruction.
SELECT
    e.id AS employee_id,
    e.employee_name AS saboteur,
    e.department,
    e.occupation,
    f.facility_name,
    f.access_date,
    f.access_time
FROM facility_access_logs AS f
JOIN employee_records AS e
    ON e.id = f.employee_id
WHERE f.facility_name = 'Facility 18'
  AND f.access_date = 19890421
  AND f.access_time > '09:00'
  AND f.access_time <= '09:15'
ORDER BY f.access_time;

-- Final answer to submit:
-- Hristo Bogoev

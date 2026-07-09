# SQLNoir Case #005: The Silicon Sabotage

## Objective

Find who sabotaged QuantumTech's QuantaX microprocessor prototype.

## Final Answer

**Hristo Bogoev**

## Investigation Summary

The case starts with a sabotage incident at QuantumTech HQ. The prototype was destroyed and research data was erased. The investigation moves from the incident report to witness statements, then cross-checks physical keycard activity, computer access logs, email manipulation, and facility access timing.

The key breakthrough is that no single clue identifies the culprit. The solution comes from intersecting multiple independent signals:

1. A witness saw a suspicious `QX-` keycard pattern.
2. Another witness heard a clue about a Helsinki server.
3. Joining those two clues identifies **Elizabeth Gordon** as a staged participant.
4. Elizabeth's statement reveals she was lured by an email about an alarm issue.
5. The email trail leads to **Norman Owens**, who received anonymous instructions.
6. The anonymous instructions mention **Facility 18**, a planned 09:00 unlock, and a male actor using his own credentials shortly after Elizabeth leaves.
7. Facility 18 access logs show **Hristo Bogoev** entering at `09:01`, directly after the planned unlock window.

## Step-by-Step Investigation Process

### 1. Locate the QuantumTech incident

Query the `incident_reports` table for the QuantumTech HQ incident.

Expected result:

| incident_id | incident_date | location | description |
|---:|---:|---|---|
| 74 | 19890421 | QuantumTech HQ | Prototype destroyed; data erased from servers. |

This establishes the key date: **1989-04-21**.

### 2. Pull witness statements for the incident

Using `incident_id = 74`, query `witness_statements` and join to `employee_records`.

Two useful witnesses appear:

| witness | clue |
|---|---|
| Carl Jenkins | Heard someone mention a server in Helsinki. |
| Tina Ruiz | Saw someone holding a `QX-` keycard followed by an odd two-digit number. |

These are the first two investigative filters.

### 3. Investigate the QX keycard clue

Filtering `keycard_access_logs` for `QX-` keycards with odd final two digits returns many employees.

Conclusion: this clue is useful but too broad on its own.

### 4. Investigate the Helsinki server clue

Filtering `computer_access_logs` for `server_location = 'Helsinki'` on the incident date also returns multiple employees.

Conclusion: this clue is also too broad on its own.

### 5. Intersect both clues

Join the QX keycard suspect pool with the Helsinki server access pool using `employee_id` and `access_date`.

Expected result:

| employee_id | employee_name | keycard_code | server_location |
|---:|---|---|---|
| 99 | Elizabeth Gordon | QX-035 | Helsinki |

At this stage, Elizabeth looks suspicious. But the investigation should not stop here because she may have been manipulated.

### 6. Review Elizabeth Gordon's statement

Elizabeth says she received an email from a colleague claiming there was an alarm problem near the chip. She went to check it but found nothing unusual.

This reframes Elizabeth from primary culprit to possible decoy.

### 7. Trace the email sent to Elizabeth

Query `email_logs` where Elizabeth is the recipient on the incident date.

Expected result:

| sender | recipient | subject |
|---|---|---|
| Norman Owens | Elizabeth Gordon | Alarm System Concern |

Norman sent the email that moved Elizabeth into position.

### 8. Inspect Norman Owens's suspicious emails

Norman received two anonymous emails from `sender_employee_id IS NULL`.

The important instructions are:

| subject | meaning |
|---|---|
| Realign Asset Trajectory | Send “L” into Facility 18 before 9. |
| Execute Phase Window | Unlock Facility 18 by 9; a male actor will use his own credentials shortly after L leaves. |

“L” refers to Elizabeth being used as a planted trail. The true culprit is the person who entered Facility 18 shortly after the planned unlock window.

### 9. Check Facility 18 access logs

Query `facility_access_logs` for `Facility 18` on `19890421`, ordered by access time.

Important timeline:

| time | employee | interpretation |
|---|---|---|
| 08:55 | Elizabeth Gordon | Lured into Facility 18. |
| 09:01 | Hristo Bogoev | Enters shortly after the 09:00 unlock instruction. |

The anonymous email said the real actor would enter using his own credentials shortly after the unlock. That matches **Hristo Bogoev**.

## Final Conclusion

**Hristo Bogoev** sabotaged the QuantaX microprocessor.

The strongest evidence is the Facility 18 timeline combined with the anonymous email instructions. Elizabeth Gordon was used as a decoy, Norman Owens was used to move her into place, and Hristo Bogoev entered Facility 18 at the decisive time.

## SQL Concepts Used

- Filtering with `WHERE`
- Pattern matching with `LIKE`
- String extraction with `substr()`
- Numeric casting with `CAST()`
- Joining tables with `JOIN`
- Handling anonymous senders with `IS NULL`
- Time-window filtering with ordered logs
- Building evidence through CTEs

## Files

- `investigation.sql` — complete SQL query flow.
- `solution.md` — written explanation of the investigation path and conclusion.

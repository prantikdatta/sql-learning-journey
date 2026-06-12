# 1661. Average Time of Process per Machine

## Problem

Given an `Activity` table:

| Column Name | Type |
|---|---|
| machine_id | int |
| process_id | int |
| activity_type | enum |
| timestamp | float |

`(machine_id, process_id, activity_type)` is the primary key.

Each machine runs multiple processes. For every `(machine_id, process_id)` pair, there is one `start` row and one `end` row.

Write a SQL query to find the average time each machine takes to complete a process.

The processing time for one process is:

```text
end timestamp - start timestamp

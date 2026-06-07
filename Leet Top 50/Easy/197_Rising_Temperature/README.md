# 197. Rising Temperature

## Approach

Join the Weather table with itself.

- `w1` represents the current day.
- `w2` represents the previous day.
- `DATEDIFF(w1.recordDate, w2.recordDate) = 1` ensures the dates are consecutive.
- Return the id where today's temperature is greater than yesterday's.

## SQL

```sql
SELECT w1.id
FROM Weather w1
JOIN Weather w2
    ON DATEDIFF(w1.recordDate, w2.recordDate) = 1
WHERE w1.temperature > w2.temperature;
```

SELECT e.employee_id AS employee_id
FROM Employees e
LEFT JOIN Employees e1
    ON e1.employee_id = e.manager_id
WHERE e.salary < 30000
  AND e1.employee_id IS NULL
  AND e.manager_id IS NOT NULL
ORDER BY e.employee_id;

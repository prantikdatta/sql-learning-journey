-- LeetCode 184. Department Highest Salary

SELECT
    d.name AS Department,
    e.name AS Employee,
    e.salary AS Salary
FROM Employee e
JOIN Department d
    ON e.departmentId = d.id
WHERE e.salary = (
    SELECT MAX(e1.salary)
    FROM Employee e1
    WHERE e1.departmentId = d.id
);

SELECT *
FROM Users
WHERE mail COLLATE utf8mb3_bin
REGEXP '^[A-Za-z][A-Za-z0-9._-]*@leetcode\\.com$';

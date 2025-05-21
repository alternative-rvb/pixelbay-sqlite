-- database: ../../pixelbay-sqlite.db
-- WHERE LIKE IN

SELECT * FROM depenses d
WHERE d.description LIKE ('%a%', '%b%');
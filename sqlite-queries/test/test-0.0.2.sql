-- database: ../../pixelbay-sqlite.db
-- WHERE LIKE IN

SELECT * FROM depenses d
WHERE d.magasin_id IN ('1', '2');
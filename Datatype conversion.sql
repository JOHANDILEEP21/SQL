SHOW DATABASES;

USE HR_database;

CREATE TABLE IF NOT EXISTS datatype_conversion (
col1 int, col2 varchar(50), col3 DATETIME, col4 int
);

INSERT INTO datatype_conversion (col1, col2, col3, col4)
SELECT 123 AS col1, '123' AS col2, NOW() AS col3, null AS col4; 

SELECT * FROM datatype_conversion;

SELECT 1+2;

SELECT '1'+'2';

SELECT '1'+a; -- Can't do any operations between two different datatypes.

INSERT INTO datatype_conversion VALUES (234,'234',NOW(), 0);

SELECT * FROM datatype_conversion;

SET AUTOCOMMIT = 0;

START TRANSACTION;

INSERT INTO datatype_conversion VALUES (456,'456',NOW(), 4556);
COMMIT;

INSERT INTO datatype_conversion VALUES (789,'789',NOW(), 798);
INSERT INTO datatype_conversion VALUES (159,'159',NOW(), 159);
INSERT INTO datatype_conversion VALUES (753,'753',NOW(), 753);
COMMIT;

ROLLBACK;

SELECT * FROM datatype_conversion;


USE hr_database;

SHOW TABLES;
SELECT * FROM employees;

-- ---------------------------------------------------------------------------------
-- Datatype conversion: 
-- ---------------------------------------------------------------------------------
ALTER TABLE amazon_data
MODIFY Title TEXT;

-- ---------------------------------------------------------------------------------
-- How to add values to the auto_increment
-- ---------------------------------------------------------------------------------




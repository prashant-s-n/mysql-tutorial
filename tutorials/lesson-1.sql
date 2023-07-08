-- Create database
CREATE DATABASE school;

-- Set database
USE school;

-- Drop table -- Delete data + columns
DROP TABLE students;

-- Truncate - only data
TRUNCATE students;

-- Create Students table
CREATE TABLE students (
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    dob DATE,
    mothers_name VARCHAR(100),
    fathers_name VARCHAR(100),
    state VARCHAR(20),
    phone_no VARCHAR(20),
    stream VARCHAR(20) NOT NULL DEFAULT 'NA',
    created_by BIGINT,
    created_on DATETIME,
    updated_by BIGINT,
    updated_on DATETIME
);

-- Create records in students
INSERT INTO students (id, name, dob, mothers_name, fathers_name, state, phone_no, stream, created_by, created_on, updated_by, updated_on)
			VALUES (1, 'Santosh', '1997-07-01', 'Abc', 'BCD', 'Maharashtra', '9769278412', 'Science', 1, NOW(), 1, NOW());
            
-- Create records with Auto increment
INSERT INTO students (name, dob, mothers_name, fathers_name, state, phone_no, stream, created_by, created_on, updated_by, updated_on)
			VALUES ('Prashant', '1997-07-01', 'Abc', 'BCD', 'Maharashtra', '9769278412', 'Science', 1, NOW(), 1, NOW());

-- Create records with default stream
INSERT INTO students (name, dob, mothers_name, fathers_name, state, phone_no, created_by, created_on, updated_by, updated_on)
			VALUES ('Aditya', '1998-07-01', 'Abc', 'BCD', 'Maharashtra', '9769278412', 1, NOW(), 1, NOW());
            
-- Update Aditya's stream
UPDATE students 
SET stream = 'Science', updated_by = 2, updated_on = NOW()
WHERE id = 3; 

-- Delete Aditya's record
DELETE FROM students
WHERE id = 3;

-- Check record in students
SELECT * FROM students;

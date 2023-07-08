-- Extract student information
SELECT * FROM students;

-- Create a table called student_fees_information
CREATE TABLE student_fees_information (
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
    student_id BIGINT ,
    fee_amount DECIMAL(10,2) DEFAULT 0,
    total_paid DECIMAL(10,2) DEFAULT 0,
    balance DECIMAL(10,2) DEFAULT 0,
    is_paid ENUM('PAID', 'UNPAID') DEFAULT 'UNPAID',
    created_by BIGINT,
    created_on DATETIME,
    updated_by BIGINT,
    updated_on DATETIME,
    FOREIGN KEY (student_id) REFERENCES students(id)
);

-- Extract student fees information
SELECT * FROM student_fees_information;

-- Create a record for a fee information
INSERT INTO student_fees_information (student_id, fee_amount, total_paid, balance, created_by, created_on, updated_by, updated_on)
			VALUES (1, 100, 0, 100, 1, NOW(), 1, NOW());

INSERT INTO student_fees_information (student_id, fee_amount, total_paid, balance, created_by, created_on, updated_by, updated_on)
			VALUES (2, 100, 0, 100, 1, NOW(), 1, NOW());

INSERT INTO student_fees_information (student_id, fee_amount, total_paid, balance, created_by, created_on, updated_by, updated_on)
			VALUES (3, 100, 0, 100, 1, NOW(), 1, NOW());
            
-- Student name and his fee information
SELECT 
	s.id, 
    s.name,
    sfi.fee_amount,
    sfi.total_paid,
    sfi.balance,
    sfi.is_paid
FROM students s
LEFT JOIN student_fees_information sfi ON sfi.student_id = s.id;


-- Students who do not have fee records
SELECT 
	s.id, 
    s.name,
    sfi.fee_amount,
    sfi.total_paid,
    sfi.balance,
    sfi.is_paid
FROM students s
LEFT JOIN student_fees_information sfi ON sfi.student_id = s.id
WHERE fee_amount IS NULL;

-- Students whose fees is unpaid
SELECT 
	s.id, 
    s.name,
    sfi.fee_amount,
    sfi.total_paid,
    sfi.balance,
    sfi.is_paid
FROM students s
LEFT JOIN student_fees_information sfi ON sfi.student_id = s.id
WHERE is_paid = 'UNPAID';

-- DROP table student_fees_payments
DROP TABLE student_fees_payments;

-- Create table for fees payment information
CREATE TABLE student_fees_payments (
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
    fee_id BIGINT ,
    payment_amount DECIMAL(10,2),
    created_by BIGINT,
    created_on DATETIME,
    updated_by BIGINT,
    updated_on DATETIME,
    FOREIGN KEY (fee_id) REFERENCES student_fees_information(id)
);

-- Extract payment information
SELECT * FROM student_fees_payments;

-- Create a payment entry

INSERT INTO student_fees_payments (fee_id, payment_amount, created_by, created_on, updated_by, updated_on)
			VALUES (1, 30, 1, NOW(), 1, NOW());
            
INSERT INTO student_fees_payments (fee_id, payment_amount, created_by, created_on, updated_by, updated_on)
			VALUES (1, 30, 1, NOW(), 1, NOW());

INSERT INTO student_fees_payments (fee_id, payment_amount, created_by, created_on, updated_by, updated_on)
			VALUES (1, 40, 1, NOW(), 1, NOW());

INSERT INTO student_fees_payments (fee_id, payment_amount, created_by, created_on, updated_by, updated_on)
			VALUES (2, 99, 1, NOW(), 1, NOW());


INSERT INTO student_fees_payments (fee_id, payment_amount, created_by, created_on, updated_by, updated_on)
			VALUES (2, 1, 1, NOW(), 1, NOW());
            
            
SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

-- Gather fee information
SELECT 
	s.id, 
    s.name,
    sfi.fee_amount,
    sfi.total_paid,
    sfi.balance,
    sfi.is_paid,
    SUM(sfp.payment_amount) as payment_amount
FROM students s
LEFT JOIN student_fees_information sfi ON sfi.student_id = s.id
LEFT JOIN student_fees_payments sfp ON sfp.fee_id = sfi.id
GROUP BY s.id;


-- Update fee information from payments made
UPDATE student_fees_information sfi
SET total_paid = (SELECT SUM(payment_amount) FROM student_fees_payments WHERE fee_id = 2),
	balance = (fee_amount - total_paid),
    is_paid = IF(balance = 0, 'PAID', 'UNPAID')
WHERE sfi.id = 2;

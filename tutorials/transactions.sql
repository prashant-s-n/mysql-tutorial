-- Create a database
CREATE DATABASE bank;

-- Create a user table
CREATE TABLE users (
	id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(250) NOT NULL,
    full_name VARCHAR(250) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE accounts (
	id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    account_no VARCHAR(250) NOT NULL,
    current_balance DECIMAL(10, 3) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    account_status ENUM('active', 'inactive') DEFAULT 'inactive'
);


CREATE TABLE account_transactions (
	id BIGINT AUTO_INCREMENT PRIMARY KEY,
    account_id BIGINT,
    amount DECIMAL(10, 3) NOT NULL,
    bank_ref_no VARCHAR(100) UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

USE bank;

select * from users;
select * from accounts;
select * from account_transactions;


-- MySQL

-- Create a SP called insert_transaction
DELIMITER $$
	DROP PROCEDURE IF EXISTS insert_transaction $$
	CREATE PROCEDURE insert_transaction(
		IN account_id_param BIGINT,
        IN trans_amount_param DECIMAL(10,3),
        IN bank_ref_no_param VARCHAR(50),
        OUT final_message TEXT
    ) 
    BEGIN
		-- ERROR HANDLING
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			ROLLBACK;
			SET final_message =  'An error has occurred, operation rollbacked and the stored procedure was terminated';
		END;
    
		-- SUCCESS
		START TRANSACTION;

		INSERT INTO account_transactions (account_id, amount, bank_ref_no)
			   VALUES (account_id_param , trans_amount_param, bank_ref_no_param);

        UPDATE accounts
		SET 
			current_balance = current_balance + trans_amount_param,
			account_status = CASE WHEN current_balance > 0 THEN 'active' ELSE 'inactive' END
		WHERE 
			id = account_id_param;
			   
		COMMIT ;
        
        SET final_message =  'Transaction Successful';
    END $$
DELIMITER ;

-- Call Insert Transaction
call bank.insert_transaction(1, 1000, 'H776767565695', @final_message);
SELECT @final_message;









    





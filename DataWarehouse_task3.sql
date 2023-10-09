----------------------1.Read customers, normalize their attributes, and clean them----------------------------------

CREATE TABLE DW_CUSTOMER (
  CUSTOMER_ID  NUMBER(11) NOT NULL,
  FIRST_NAME   VARCHAR2(40),
  LAST_NAME    VARCHAR2(40) NOT NULL,
  STREET       VARCHAR2(60),
  "NUMBER"     VARCHAR2(5),
  ZIP          VARCHAR2(5) NOT NULL,
  CITY         VARCHAR2(50) NOT NULL,
  GENDER       CHAR(1),
  BIRTH_DATE   DATE,
  CONSTRAINT PK_CUSTOMER PRIMARY KEY (CUSTOMER_ID),
  CONSTRAINT CHK_GENDER CHECK (GENDER IN ('w', 'm'))
);

-- Disable the check constraint
ALTER TABLE DW_CUSTOMER
DISABLE CONSTRAINT CHK_GENDER;

-- Insert normalized customer data from DWT_BRANCH_1
INSERT INTO DW_CUSTOMER (CUSTOMER_ID, FIRST_NAME, LAST_NAME, STREET, "NUMBER", ZIP, CITY, GENDER, BIRTH_DATE)
SELECT ID, NAME, SURNAME, STR, NO, ZIP, PLACE, GEND, BDAY
FROM DWT_BRANCH_1.customer;


-- Insert normalized customer data from DWT_BRANCH_2
SELECT NUM, COUNT(*) AS COUNT
FROM DWT_BRANCH_2.CUSTOMER
GROUP BY NUM
HAVING COUNT(*) > 1;

INSERT INTO DW_CUSTOMER (CUSTOMER_ID, FIRST_NAME, LAST_NAME, STREET, "NUMBER", ZIP, CITY, GENDER, BIRTH_DATE)
SELECT
  (SELECT COALESCE(MAX(CUSTOMER_ID), 0) FROM DW_CUSTOMER) + ROW_NUMBER() OVER (ORDER BY NUM),
  FIRSTNAME, LASTNAME, NULL, NULL, SUBSTR(TO_CHAR(PLACEID), 1, 5), NULL, 'U', BDAY
FROM DWT_BRANCH_2.CUSTOMER;


ALTER TABLE DW_CUSTOMER MODIFY (CITY VARCHAR2(50) NULL);

-- Insert normalized customer data from DWT_BRANCH_6
SELECT CCODE, COUNT(*)
FROM DWT_BRANCH_6.CUSTOMER
GROUP BY CCODE
HAVING COUNT(*) > 1;

INSERT INTO DW_CUSTOMER (CUSTOMER_ID, FIRST_NAME, LAST_NAME, STREET, "NUMBER", ZIP, CITY, GENDER, BIRTH_DATE)
SELECT
  ROW_NUMBER() OVER (ORDER BY CCODE) + (SELECT MAX(CUSTOMER_ID) FROM DW_CUSTOMER),
  FIRSTNAME,
  SURNAME,
  STR_NO,
  NULL,
  SUBSTR(ZIP_PLACE, 1, 5),
  NULL,
  GENDER,
  BDAY
FROM DWT_BRANCH_6.CUSTOMER;



--------------------------------2 . Detect duplicate customer tuples, i. e. when a customer is registered in multiple branches---------------------------
---------------------------------and would thus be multiple times in your database, if you simply copied the data.
SELECT CUSTOMER_ID, COUNT(*) AS DUPLICATE_COUNT
FROM DW_CUSTOMER
GROUP BY CUSTOMER_ID
HAVING COUNT(*) > 1;

select * from DW_CUSTOMER

----------------------------------3.Read products, normalize and clean their attributes------------------------------------------------------------------
-- Create the normalized products table
CREATE TABLE dw_totalproduct (
  product_id NUMBER(11) PRIMARY KEY,
  product_name VARCHAR2(50),
  product_type VARCHAR2(30),
  product_size NUMBER(3,2),
  product_price NUMBER(3,2)
);

-- Insert data from DWT_BRANCH_1
INSERT INTO dw_totalproduct (product_id, product_name, product_type, product_size, product_price)
SELECT ID, NAME, SORT, SZ, PRICE
FROM DWT_BRANCH_1.products;

-- Insert data from DWT_BRANCH_2
-- Insert data from DWT_BRANCH_2 with handling of invalid numeric values
DECLARE
  max_product_id NUMBER;
BEGIN
  SELECT MAX(product_id) INTO max_product_id FROM dw_totalproduct;
  
  -- Insert data from DWT_BRANCH_2 with new product IDs
  INSERT INTO dw_totalproduct (product_id, product_name, product_type, product_size, product_price)
  SELECT max_product_id + ROW_NUMBER() OVER (ORDER BY NUM) AS new_product_id, LABEL, TYPE, LITER, TO_NUMBER(REPLACE(PRICE, ',', '.'))
  FROM DWT_BRANCH_2.PRODUCT;
END;

-- Insert data from DWT_BRANCH_6

DECLARE
  max_product_id NUMBER;
BEGIN
  SELECT MAX(product_id) INTO max_product_id FROM dw_totalproduct;
  
  -- Insert data from DWT_BRANCH_6.PRODUCT with new product IDs
  FOR rec IN (
    SELECT IDCODE, NAME_VOL, PRICE
    FROM DWT_BRANCH_6.PRODUCT
  )
  LOOP
    DECLARE
      product_name VARCHAR2(50);
      product_size NUMBER(3,2);
      product_price NUMBER(3,2);
    BEGIN
      -- Split NAME_VOL into product_name and product_size
      product_name := SUBSTR(rec.NAME_VOL, 1, INSTR(rec.NAME_VOL, ' ') - 1);
      product_size := TO_NUMBER(SUBSTR(rec.NAME_VOL, INSTR(rec.NAME_VOL, ' ') + 1));
      
      -- Convert PRICE to number
      product_price := TO_NUMBER(REPLACE(rec.PRICE, ',', '.'));

      -- Insert into dw_totalproduct
      INSERT INTO dw_totalproduct (product_id, product_name, product_type, product_size, product_price)
      VALUES (max_product_id + rec.IDCODE, product_name, NULL, product_size, product_price);
      
    EXCEPTION
      WHEN VALUE_ERROR THEN
        NULL;
      WHEN OTHERS THEN
        NULL;
    END;
  END LOOP;
END;

--------------------------------------------4. Calculate the turnover (sales volume)--------------------------------------------------------

-- Create the turnover table
CREATE TABLE dw_turnover (
  branch_id VARCHAR2(20),
  turnover NUMBER(10,2),
  PRIMARY KEY (branch_id)
);

-- Calculate turnover for DWT_BRANCH_1
INSERT INTO dw_turnover (branch_id, turnover)
SELECT 'DWT_BRANCH_1' AS branch_id, SUM("AMOUNT") AS turnover
FROM DWT_BRANCH_1."ORDER";


-- Calculate turnover for DWT_BRANCH_2 with German number words
INSERT INTO dw_turnover (branch_id, turnover)
SELECT 'DWT_BRANCH_2' AS branch_id, SUM(
  CASE
    WHEN AMOUNT = 'eins' THEN 1
    WHEN AMOUNT = 'zwei' THEN 2
    WHEN AMOUNT = 'drei' THEN 3
    WHEN AMOUNT = 'vier' THEN 4
    -- Add more cases for other German number words as needed
    ELSE 0 
  END
) AS turnover
FROM DWT_BRANCH_2.BUYS;


select * from DWT_BRANCH_2.BUYS;
-- Calculate turnover for DWT_BRANCH_6
INSERT INTO dw_turnover (branch_id, turnover)
SELECT 'DWT_BRANCH_6' AS branch_id, SUM(AMOUNT) AS turnover
FROM DWT_BRANCH_6.ORDERS;


-------------------------5. Calculate the amount of sales in liters for the turnover calculation---------------------------------------
-- Create the sales volume table
CREATE TABLE dw_sales_volume (
  branch_id VARCHAR2(20),
  sales_volume NUMBER(10,2),
  PRIMARY KEY (branch_id)
);

-- Calculate sales volume in liters for DWT_BRANCH_1
INSERT INTO dw_sales_volume (branch_id, sales_volume)
SELECT 'DWT_BRANCH_1' AS branch_id, SUM(SZ * AMOUNT) AS sales_volume
FROM DWT_BRANCH_1."ORDER"
JOIN DWT_BRANCH_1.products ON DWT_BRANCH_1."ORDER"."PRO" = DWT_BRANCH_1.products.ID;

-- Calculate sales volume in liters for DWT_BRANCH_2
INSERT INTO dw_sales_volume (branch_id, sales_volume)
SELECT 'DWT_BRANCH_2' AS branch_id, SUM(
  CASE
    WHEN REGEXP_LIKE(LITER, '^(eins|one)$', 'i') THEN 1
    WHEN REGEXP_LIKE(LITER, '^(zwei|two)$', 'i') THEN 2
    WHEN REGEXP_LIKE(LITER, '^(drei|three)$', 'i') THEN 3
    WHEN REGEXP_LIKE(LITER, '^(vier|four)$', 'i') THEN 4
    ELSE 0 
  END * 
  CASE
    WHEN REGEXP_LIKE(AMOUNT, '^-?[0-9]+(\.[0-9]+)?$', 'i') THEN TO_NUMBER(AMOUNT)
    ELSE 0 
  END
) AS sales_volume
FROM DWT_BRANCH_2.BUYS
JOIN DWT_BRANCH_2.PRODUCT ON DWT_BRANCH_2.BUYS.PNUMBER = DWT_BRANCH_2.PRODUCT.NUM;



-- Calculate sales volume in liters for DWT_BRANCH_6
INSERT INTO dw_sales_volume (branch_id, sales_volume)
SELECT 'DWT_BRANCH_6' AS branch_id, SUM(
  AMOUNT * TO_NUMBER(REGEXP_REPLACE(NAME_VOL, '[^0-9.]', ''))
) AS sales_volume
FROM DWT_BRANCH_6.ORDERS
JOIN DWT_BRANCH_6.PRODUCT ON DWT_BRANCH_6.ORDERS.KC = DWT_BRANCH_6.PRODUCT.IDCODE;


select * from DWT_BRANCH_6.product
desc DWT_BRANCH_6.product
-------------------------------6. Determine the age groups of customers------------------------------------------------------------------------

SELECT 
  CUSTOMER_ID,
  FIRST_NAME,
  LAST_NAME,
  CASE 
    WHEN MONTHS_BETWEEN(SYSDATE, BIRTH_DATE) / 12 <= 15 THEN 'Child'
    WHEN MONTHS_BETWEEN(SYSDATE, BIRTH_DATE) / 12 <= 19 THEN 'Youngster'
    WHEN MONTHS_BETWEEN(SYSDATE, BIRTH_DATE) / 12 <= 29 THEN 'Young Adult'
    WHEN MONTHS_BETWEEN(SYSDATE, BIRTH_DATE) / 12 <= 49 THEN 'Adult'
    ELSE 'Old Adult'
  END AS AGE_GROUP
FROM DW_CUSTOMER;












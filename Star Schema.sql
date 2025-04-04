-- Fact Table: Payment Fact
CREATE TABLE payment_fact (
    payment_key VARCHAR2(12) PRIMARY KEY,
    customer_key VARCHAR2(12),
    time_key VARCHAR2(12),
    item_key VARCHAR2(12),
    store_key VARCHAR2(12),
    quantity NUMBER,
    unit VARCHAR2(50),
    unit_price NUMBER(10,2),
    total_price NUMBER(12,2)
);

-- Transaction Dimension
CREATE TABLE trans_dimension (
    payment_key VARCHAR2(12) PRIMARY KEY,
    trans_type VARCHAR2(50),
    bank_name VARCHAR2(100)
);

-- Item Dimension
CREATE TABLE item_dimension (
    item_key VARCHAR2(12) PRIMARY KEY,
    item_name VARCHAR2(100),
    description VARCHAR2(255),
    unit_price NUMBER(10,2),
    man_country VARCHAR2(100),
    supplier VARCHAR2(100),
    stock_quantity NUMBER,
    unit VARCHAR2(50)
);

-- Customer Dimension
CREATE TABLE customer_dimension (
    customer_key VARCHAR2(12) PRIMARY KEY,
    name VARCHAR2(100),
    contact_no VARCHAR2(20),
    nid VARCHAR2(30),
    address VARCHAR2(255),
    street VARCHAR2(100),
    upazila VARCHAR2(100),
    district VARCHAR2(100),
    division VARCHAR2(100)
);

-- Time Dimension
CREATE TABLE time_dimension (
    time_key VARCHAR2(12) PRIMARY KEY,
    date_value DATE,
    hour NUMBER,
    day NUMBER,
    week VARCHAR2(12),
    month NUMBER,
    quarter VARCHAR2(12),
    year NUMBER
);

-- Store Dimension
CREATE TABLE store_dimension (
    store_key VARCHAR2(12) PRIMARY KEY,
    location VARCHAR2(255),
    city VARCHAR2(100),
    upazila VARCHAR2(100),
    district VARCHAR2(100)
);

-- Foreign Key Constraints
ALTER TABLE payment_fact ADD CONSTRAINT fk_payment_customer FOREIGN KEY (customer_key) REFERENCES customer_dimension(customer_key);
ALTER TABLE payment_fact ADD CONSTRAINT fk_payment_time FOREIGN KEY (time_key) REFERENCES time_dimension(time_key);
ALTER TABLE payment_fact ADD CONSTRAINT fk_payment_item FOREIGN KEY (item_key) REFERENCES item_dimension(item_key);
ALTER TABLE payment_fact ADD CONSTRAINT fk_payment_store FOREIGN KEY (store_key) REFERENCES store_dimension(store_key);

ALTER TABLE trans_dimension ADD CONSTRAINT fk_trans_payment FOREIGN KEY (payment_key) REFERENCES payment_fact(payment_key);


DROP TABLE payment_fact;
DROP TABLE time_dimension;
DROP TABLE item_dimension;
DROP TABLE store_dimension;
DROP TABLE customer_dimension;
DROP TABLE trans_dimension;

BEGIN
  FOR i IN (SELECT table_name FROM user_tables) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || i.table_name || ' CASCADE CONSTRAINTS FORCE';
  END LOOP;
END;
/


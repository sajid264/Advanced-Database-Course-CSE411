CREATE TABLE customer_dimension (
    coustomer_key VARCHAR2(10) PRIMARY KEY,
    name VARCHAR2(100),
    contact_no VARCHAR2(50),
    nid VARCHAR2(50),
    address VARCHAR2(255),
    street VARCHAR2(100),
    upazila VARCHAR2(100),
    district VARCHAR2(100),
    division VARCHAR2(100)
);

CREATE TABLE time_dimension (
    time_key VARCHAR2(10) PRIMARY KEY,
    date_value DATE,
    hour NUMBER,
    day NUMBER,
    week VARCHAR2(10),
    month NUMBER,
    quarter VARCHAR2(10),
    year NUMBER
);

CREATE TABLE item_dimension (
    item_key VARCHAR2(10) PRIMARY KEY,
    item_name VARCHAR2(100),
    description VARCHAR2(255),
    unit_price NUMBER,
    man_country VARCHAR2(100),
    supplier VARCHAR2(100),
    stock_quantity NUMBER,
    unit VARCHAR2(50)
);

CREATE TABLE store_dimension (
    store_key VARCHAR2(10) PRIMARY KEY,
    location VARCHAR2(100),
    city VARCHAR2(100),
    upazila VARCHAR2(100),
    district VARCHAR2(100)
);
CREATE TABLE trans_dimension (
    trans_key VARCHAR2(10) PRIMARY KEY,
    trans_type VARCHAR2(50),
    bank_name VARCHAR2(100)
);


CREATE TABLE fact_payment (
    payment_key VARCHAR2(10) PRIMARY KEY,
    coustomer_key VARCHAR2(10),
    time_key VARCHAR2(10),
    item_key VARCHAR2(10),
    store_key VARCHAR2(10),
    trans_key VARCHAR2(10),
    quantity NUMBER,
    unit VARCHAR2(50),
    unit_price NUMBER,
    total_price NUMBER,

    CONSTRAINT fk_fact_customer FOREIGN KEY (coustomer_key) REFERENCES customer_dimension(coustomer_key),
    CONSTRAINT fk_fact_time FOREIGN KEY (time_key) REFERENCES time_dimension(time_key),
    CONSTRAINT fk_fact_item FOREIGN KEY (item_key) REFERENCES item_dimension(item_key),
    CONSTRAINT fk_fact_store FOREIGN KEY (store_key) REFERENCES store_dimension(store_key),
    CONSTRAINT fk_fact_trans FOREIGN KEY (trans_key) REFERENCES trans_dimension(trans_key)
);




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


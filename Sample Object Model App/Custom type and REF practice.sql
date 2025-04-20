-- Scenario: We have Customer_objtyp and Order_objtyp. Each order is placed by a customer, and we'll use a REF in the Order_objtyp to point to the customer who placed the order.

-- Why do we need create or replace?
-- because you can create blank types to fil later on.

-- create type animal; wil create a blank type.

-- create or replace type animal as object (
--     id Number,
--     name VARCHAR2(52)
-- );
--  this will fill the blanks.


-- Step 1: Create the Customer_objtyp and its table:

CREATE TYPE Customer_objtyp AS OBJECT (
  customer_id   NUMBER,
  first_name    VARCHAR2(50),
  last_name     VARCHAR2(50),
  email         VARCHAR2(100)
);
/

CREATE TABLE Customers_table OF Customer_objtyp (
  CONSTRAINT customer_pk PRIMARY KEY (customer_id)
);

INSERT INTO Customers_table VALUES (1, 'Alice', 'Smith', 'alice.smith@example.com');
INSERT INTO Customers_table VALUES (2, 'Bob', 'Johnson', 'bob.johnson@example.com');
INSERT INTO Customers_table VALUES (3, 'Charlie', 'Brown', 'charlie.brown@example.com');
COMMIT;


-- Step 2: Create the Order_objtyp with a REF to Customer_objtyp and its table:

CREATE TYPE Order_objtyp AS OBJECT (
  order_id    NUMBER,
  order_date  DATE,
  total_amount NUMBER,
  customer_ref REF Customer_objtyp  -- The REF attribute
);
/

CREATE TABLE Orders_table OF Order_objtyp (
  CONSTRAINT order_pk PRIMARY KEY (order_id)
);


-- Step 3: Insert data into the Orders_table and set the REF:

INSERT INTO Orders_table
SELECT
  101,
  SYSDATE,
  100.00,
  (SELECT REF(c) FROM Customers_table c WHERE c.customer_id = 1)
FROM dual;

INSERT INTO Orders_table
SELECT
  102,
  SYSDATE,
  25.50,
  (SELECT REF(c) FROM Customers_table c WHERE c.customer_id = 2)
FROM dual;

INSERT INTO Orders_table
SELECT
  103,
  SYSDATE,
  120.00,
  (SELECT REF(c) FROM Customers_table c WHERE c.customer_id = 1)
FROM dual;

COMMIT;


-- Step 4: Querying data and dereferencing the REF to get customer details:

SELECT
  o.order_id,
  o.order_date,
  o.total_amount,
  o.customer_ref.first_name,  -- Access customer first name
  o.customer_ref.last_name,   -- Access customer last name
  o.customer_ref.email       -- Access customer email
FROM
  Orders_table o;


-- Output:
-- ORDER_ID ORDER_DATE  TOTAL_AMOUNT FIRST_NAME LAST_NAME  EMAIL
-- -------- ----------- ------------ ---------- ---------- --------------------------
--      101 20-APR-2025       100.00 Alice      Smith      alice.smith@example.com
--      102 20-APR-2025        25.50 Bob        Johnson    bob.johnson@example.com
--      103 20-APR-2025       120.00 Alice      Smith      alice.smith@example.com


-- Step 5: Using the DEREF() function:

SELECT
  o.order_id,
  o.order_date,
  o.total_amount,
  DEREF(o.customer_ref).first_name,
  DEREF(o.customer_ref).last_name,
  DEREF(o.customer_ref).email
FROM
  Orders_table o;


-- This will give the same result as the previous query.
-- Step 6: Joining with the Customer table (Alternative, for comparison):
-- While REF is designed for object-oriented relationships, you could also get the same data using a traditional join. This shows the difference in approach:

SELECT
  o.order_id,
  o.order_date,
  o.total_amount,
  c.first_name,
  c.last_name,
  c.email
FROM
  Orders_table o,
  Customers_table c
WHERE
  DEREF(o.customer_ref) = c;  -- Join using DEREF()


-- or, if you have the object id:
SELECT
  o.order_id,
  o.order_date,
  o.total_amount,
  c.first_name,
  c.last_name,
  c.email
FROM
  Orders_table o,
  Customers_table c
WHERE
  o.customer_ref = REF(c);


-- Key Points from the Examples:
-- We create the customer and order object types.
-- The Orders_table includes a customer_ref attribute of type REF Customer_objtyp.
-- We use a subquery with the REF() operator to get the reference to a specific customer when inserting data into the Orders_table.
-- We use the dereference operator (->) or the DEREF() function to access the customer's attributes through the customer_ref.
-- The examples show how REF establishes a relationship between orders and customers, allowing you to retrieve customer information from the Orders_table.


-- Note: The FROM DUAL is there because Oracle SQL syntax requires a FROM clause in a SELECT statement.  Since the subquery is calculating a REF based on the Customers_table, and doesn't need to select from any other table, DUAL is used as a dummy table to fulfill the requirement.
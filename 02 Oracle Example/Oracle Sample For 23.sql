-- Demo: Oracle 23c Object Tables with Nested Tables and REF Scopes
-- Drop existing objects (if any)
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE PurchaseOrder_objtab CASCADE CONSTRAINTS PURGE';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Customer_objtab CASCADE CONSTRAINTS PURGE';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TYPE PurchaseOrder_objtyp FORCE';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TYPE Customer_objtyp FORCE';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TYPE Address_objtyp FORCE';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TYPE LineItem_objtyp FORCE';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TYPE LineItemList_ntabtyp FORCE';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
-- 1) Define Address object type
CREATE TYPE Address_objtyp AS OBJECT (
  street   VARCHAR2(100),
  city     VARCHAR2(50),
  state    VARCHAR2(50),
  postal   VARCHAR2(20)
);
/
-- 2) Define Customer object type with a map method
CREATE TYPE Customer_objtyp AS OBJECT (
  cust_id   NUMBER,
  name      VARCHAR2(100),
  addr      Address_objtyp,
  MAP MEMBER FUNCTION getId RETURN NUMBER
);
/
CREATE TYPE BODY Customer_objtyp AS
  MAP MEMBER FUNCTION getId RETURN NUMBER IS
  BEGIN
    RETURN cust_id;
  END getId;
END;
/
-- 3) Create table of Customer_objtyp with proper PK syntax
CREATE TABLE Customer_objtab OF Customer_objtyp (
  PRIMARY KEY (cust_id)
);
/
-- 4) Define LineItem object type with a member function
CREATE TYPE LineItem_objtyp AS OBJECT (
  LineItemNo   NUMBER,
  ProductName  VARCHAR2(100),
  Quantity     NUMBER,
  Price        NUMBER,
  MEMBER FUNCTION totalPrice RETURN NUMBER
);
/
CREATE TYPE BODY LineItem_objtyp AS
  MEMBER FUNCTION totalPrice RETURN NUMBER IS
  BEGIN
    RETURN Quantity * Price;
  END totalPrice;
END;
/
-- 5) Define nested table type for line items
CREATE TYPE LineItemList_ntabtyp AS TABLE OF LineItem_objtyp;
/
-- 6) Define PurchaseOrder object type with map and sumLineItems
CREATE TYPE PurchaseOrder_objtyp AS OBJECT (
  PONo             NUMBER,
  CustRef          REF Customer_objtyp,
  OrderDate        DATE,
  ShipDate         DATE,
  LineItemList_ntab LineItemList_ntabtyp,
  ShiptoAddress    Address_objtyp,
  MAP MEMBER FUNCTION getPONo RETURN NUMBER,
  MEMBER FUNCTION sumLineItems RETURN NUMBER
);
/
CREATE TYPE BODY PurchaseOrder_objtyp AS
  MAP MEMBER FUNCTION getPONo RETURN NUMBER IS
  BEGIN
    RETURN PONo;
  END getPONo;

  MEMBER FUNCTION sumLineItems RETURN NUMBER IS
    v_sum NUMBER := 0;
  BEGIN
    FOR i IN 1..SELF.LineItemList_ntab.COUNT LOOP
      v_sum := v_sum + SELF.LineItemList_ntab(i).Quantity * SELF.LineItemList_ntab(i).Price;
    END LOOP;
    RETURN v_sum;
  END sumLineItems;
END;
/
-- 7) Create PurchaseOrder table of PurchaseOrder_objtyp with correct syntax
CREATE TABLE PurchaseOrder_objtab OF PurchaseOrder_objtyp (
  PRIMARY KEY (PONo)
)
  NESTED TABLE LineItemList_ntab STORE AS PoLine_ntab (
    PRIMARY KEY (NESTED_TABLE_ID, LineItemNo)
    ORGANIZATION INDEX COMPRESS
  )
  RETURN AS LOCATOR
  SCOPE FOR CustRef IS Customer_objtab;
/
-- 8) Insert sample customers
INSERT INTO Customer_objtab VALUES (
  Customer_objtyp(
    1,
    'Alice',
    Address_objtyp('123 Main St','Dhaka','Dhaka','1207')
  )
);
INSERT INTO Customer_objtab VALUES (
  Customer_objtyp(
    2,
    'Bob',
    Address_objtyp('456 Oak Ave','Chittagong','Chittagong','4000')
  )
);
COMMIT;
/
-- 9) Insert sample purchase orders
INSERT INTO PurchaseOrder_objtab VALUES (
  PurchaseOrder_objtyp(
    1001,
    (SELECT REF(c) FROM Customer_objtab c WHERE c.cust_id = 1),
    DATE '2025-04-23',
    DATE '2025-04-25',
    LineItemList_ntabtyp(
      LineItem_objtyp(1,'Widget',10,2.5),
      LineItem_objtyp(2,'Gadget',5,5.0)
    ),
    Address_objtyp('789 Pine Rd','Dhaka','Dhaka','1213')
  )
);
INSERT INTO PurchaseOrder_objtab VALUES (
  PurchaseOrder_objtyp(
    1002,
    (SELECT REF(c) FROM Customer_objtab c WHERE c.cust_id = 2),
    DATE '2025-04-20',
    DATE '2025-04-22',
    LineItemList_ntabtyp(
      LineItem_objtyp(1,'Thingamajig',3,15.0)
    ),
    Address_objtyp('321 Maple St','Chittagong','Chittagong','4001')
  )
);
COMMIT;
/
-- 10) Query object tables and nested table contents
-- List all purchase orders
SELECT p.PONo, DEREF(p.CustRef).name AS customer,
       p.OrderDate, p.ShipDate, p.sumLineItems() AS total_amount
FROM PurchaseOrder_objtab p;

-- Drill into line items for PO 1001
SELECT li.LineItemNo, li.ProductName, li.Quantity, li.Price, li.totalPrice() AS line_total
FROM PurchaseOrder_objtab p,
     TABLE(p.LineItemList_ntab) li
WHERE p.PONo = 1001;

-- Fetch nested table rows directly
SELECT VALUE(li) AS line_item_object
FROM PurchaseOrder_objtab p,
     TABLE(p.LineItemList_ntab) li
WHERE p.PONo = 1002;

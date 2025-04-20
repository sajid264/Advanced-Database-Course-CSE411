create TYPE StockItem_objtyp as object (
    StockNo NUMBER,
    Price NUMBER,
    TaxRate NUMBER 
);

CREATE TYPE LineItem_objtyp AS OBJECT (
    LineItemNo  NUMBER,
    Stock_ref   REF StockItem_objtyp,
    Quantity    NUMBER,
    Discount    Number
);
/

CREATE or replace type PhoneList_vartyp as VARRAY(10) of VARCHAR2(20);/

-- CREATE TYPE Address_objtyp AS OBJECT (
--   Street         VARCHAR2(200),
--   City           VARCHAR2(200),
--   State          CHAR(2),
--   Zip            VARCHAR2(20)
--   ) 
-- /
create type Address_objtyp as object (
    Street VARCHAR2(52),
    City   VARCHAR2(52),
    State   VARCHAR2(52),
    Zip     VARCHAR2(20)
);
/

-- CREATE TYPE Customer_objtyp AS OBJECT (
--   CustNo           NUMBER,
--   CustName         VARCHAR2(200),
--   Address_obj      Address_objtyp,
--   PhoneList_var    PhoneList_vartyp,

--   ORDER MEMBER FUNCTION
--     compareCustOrders(x IN Customer_objtyp) RETURN INTEGER
-- ) NOT FINAL;
-- /
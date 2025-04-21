create TYPE StockItem_objtyp as object (
    StockNo NUMBER,
    Price NUMBER,
    TaxRate NUMBER 
);
/
CREATE TYPE LineItem_objtyp AS OBJECT (
    LineItemNo  NUMBER,
    Stock_ref   REF StockItem_objtyp,
    Quantity    NUMBER,
    Discount    Number
);
/


CREATE or replace type PhoneList_vartyp as VARRAY(10) of VARCHAR2(20);
/


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

create OR REPLACE type customer_objtyp as object (
    CustNo number,
    CustName varchar2(52),
    Address_obj Address_objtyp,
    PhoneList_var PhoneList_vartyp,
    ORDER MEMBER function
        compareCustOrders(x in Customer_objtyp) return integer
) not final ;
/
create type LineItemList_ntabtyp as table of LineItem_objtyp;


CREATE TYPE PurchaseOrder_objtyp AUTHID CURRENT_USER AS OBJECT (
    PONo number,
    CustRef Ref Customer_objtyp,
    OrderDate date,
    ShipDate DATE,
    LineItemList_ntab LineItemList_ntabtyp,
    ShiptoAddress_obj Address_objtyp,

    Map member function 
        getPONo RETURN NUMBER,
    
    member FUNCTION
        sumLineItems RETURN NUMBER
    );

-- CREATE OR REPLACE TYPE BODY PURCHASEORDER_OBJTYP as
--     map member function getPONo return number is 
--     BEGIN
--         RETURN PONo;
--     END;

--     member function sumLineItems return number is 
--         i integer;
--         StockVal StockItem_objtyp;
--         Total NUMBER : = 0;

--     begin
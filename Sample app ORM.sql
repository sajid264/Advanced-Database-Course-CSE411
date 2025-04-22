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


CREATE or replace TYPE PurchaseOrder_objtyp AUTHID CURRENT_USER AS OBJECT (
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
/

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

CREATE OR REPLACE TYPE BODY PURCHASEORDER_OBJTYP AS
    MAP MEMBER FUNCTION getPONo return number is 
    BEGIN
        RETURN PONO;
    END;

    MEMBER FUNCTION SUMLINEITEMS return number is

    i integer;
    StockVal StockItem_objtyp;
    Total number:= 0;

    begin
        for i in 1..self.LineItemList_ntab.COUNT LOOP
        UTL_REF.SELECT_OBJECT(LineItemList_ntab(i).Stock_ref, StockVal);
        Total := Total+ self.LineItemList_ntab(i).Quantity * StockVal.Price;
        end LOOP;
        Return TOTAL;
    END;
END;
/


CREATE OR REPLACE TYPE BODY customer_objtyp as
ORDER MEMBER FUNCTION compareCustOrders (x IN Customer_objtyp) RETURN INTEGER IS
    BEGIN
        RETURN custNo - x.custNo;
    END;
end;
/

-- object definitions finished.

-- Now to create the tables.

CREATE TABLE Customer_objtab OF customer_objtyp (custNo primary key)
    OBJECT IDENTIFIER IS PRIMARY KEY;
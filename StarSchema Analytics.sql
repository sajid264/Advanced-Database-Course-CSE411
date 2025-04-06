1. OLAP Query Examples
A. CUBE Query – Aggregating on Multiple Dimensions
This query aggregates total sales and quantity by year, city, and transaction type. With the CUBE operator, Oracle computes all possible subtotal combinations—including aggregations by each individual dimension and the grand total.

sql
Copy
Edit
SELECT 
    td.year,
    sd.city,
    tdim.trans_type,
    SUM(fp.total_price) AS total_sales,
    SUM(fp.quantity) AS total_quantity
FROM fact_payment fp
JOIN time_dimension td ON fp.time_key = td.time_key
JOIN store_dimension sd ON fp.store_key = sd.store_key
JOIN trans_dimension tdim ON fp.trans_key = tdim.trans_key
GROUP BY CUBE (td.year, sd.city, tdim.trans_type)
ORDER BY td.year, sd.city, tdim.trans_type;
Explanation:

Dimensions Involved: Year (from the time dimension), City (from the store dimension), and Transaction Type (from the transaction dimension).

Aggregation: This query returns all combinations—for example, totals by year & city, by year alone, by city alone, by transaction type alone, and the overall grand total.

B. ROLLUP Query – Hierarchical Aggregation
This query aggregates total sales and quantity by year and city in a hierarchical fashion. The ROLLUP operator computes subtotals that roll up from city to year, plus an overall total.

sql
Copy
Edit
SELECT 
    td.year,
    sd.city,
    SUM(fp.total_price) AS total_sales,
    SUM(fp.quantity) AS total_quantity
FROM fact_payment fp
JOIN time_dimension td ON fp.time_key = td.time_key
JOIN store_dimension sd ON fp.store_key = sd.store_key
GROUP BY ROLLUP (td.year, sd.city)
ORDER BY td.year, sd.city;
Explanation:

Hierarchical Aggregation: First, totals are calculated for each (year, city) pair, then for each year (across all cities), and finally a grand total.

C. PIVOT Query – Converting Rows to Columns
This example converts rows (transaction types) into columns. For instance, it shows total sales per year, with each transaction type appearing as its own column. (Assuming your transaction types include values like 'Sale', 'Refund', and 'Chargeback'.)

sql
Copy
Edit
SELECT *
FROM (
  SELECT 
      td.year, 
      tdim.trans_type, 
      fp.total_price
  FROM fact_payment fp
  JOIN time_dimension td ON fp.time_key = td.time_key
  JOIN trans_dimension tdim ON fp.trans_key = tdim.trans_key
) 
PIVOT (
  SUM(total_price) 
  FOR trans_type IN ('Sale' AS Sale, 'Refund' AS Refund, 'Chargeback' AS Chargeback)
)
ORDER BY year;
Explanation:

Data Transformation: This query aggregates total prices and pivots the transaction types into separate columns so that each row represents a year and shows the sales amounts per transaction type.

D. UNPIVOT Query – Converting Columns to Rows
If you want to view two measures (for example, quantity and total_price) as attribute–value pairs, you can unpivot them. This is useful when you want to analyze these measures in a single column.

sql
Copy
Edit
SELECT 
    payment_key, 
    attribute, 
    value
FROM fact_payment
UNPIVOT (
  value FOR attribute IN (quantity, total_price)
)
ORDER BY payment_key;
Explanation:

Data Transformation: The columns quantity and total_price are turned into rows with an attribute column (which indicates whether the row is for quantity or total_price) and a value column for the corresponding number.


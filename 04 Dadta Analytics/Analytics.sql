-- Customer Count store wise

select s.store_key store, s.upazila thana, count(distinct f.coustomer_key) customer_count, sum(f.total_price) total_sales from customer_dimension c, fact_table f, store_dimension s where f.store_key = s.store_key and c.coustomer_key = f.coustomer_key GROUP BY s.store_key, s.upazila order by thana asc;


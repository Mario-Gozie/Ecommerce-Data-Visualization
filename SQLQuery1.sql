select * from ecommerce_data$ as a 
join us_state_long_lat_codes as b
on a.customer_state = b.name
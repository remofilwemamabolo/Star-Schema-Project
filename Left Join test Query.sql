--query is to take all dimenstion product table to see if they are in fact_sales table
use SneakerStore_DB
select 
p.Product_ID, p.name, p.brand, p.colourway, p.size, y.Product_ID
from Dim_Product as p 
left join Fact_Sales as y 
on p.Product_ID = y.Product_ID

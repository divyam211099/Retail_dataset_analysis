Alter table `sales_transaction-1714027462`
Rename to sales_transaction;

Select * from customer_profiles;
Select * from product_inventory;
Select * from sales_transaction;

Desc sales_transaction; 
-- we dont have any primary key iin sales_transaction table

Select ï»¿TransactionID, count(*)
from sales_transaction
group by ï»¿TransactionID
having count(*)>1;

-- transaction id 4999 and 5000 is repeating 2 times

select * from customer_profiles;

Select count(*)  from customer_profiles
where location ='';

Update customer_profiles
Set location='Unknown' 
where location ='';


-- Question 6- Customer Purchase FREQUENCY
Select CustomerID, count(*) as NumberofTransactions
from sales_transaction
group by CustomerID
order by NumberofTransactions desc;

-- Question 7- Product Category Performance
Select pi.category, sum(st.QuantityPurchased) as totalunitssold, sum(st.QuantityPurchased*pi.price) as Totalsales
from product_inventory as pi
join sales_transaction as st on pi.ï»¿ProductID=st.ProductID
group by pi.category
order by totalsales desc;

-- Question 8- High Sale Products
Select ProductID, sum(quantitypurchased*price) as totalrevenue
from sales_transaction
group by ProductID
order by totalrevenue desc
limit 10;

-- Question -9- Low sale product
Select ProductID, sum(quantitypurchased) as totalunitssold
from sales_transaction
group by ProductID
having sum(quantitypurchased)>0
order by totalunitssold
limit 10;

-- Question -10 - Sales Trend and date formal also

Create table sales_transaction_updated as
select *, date_format(STR_TO_DATE(TransactionDate,'%d/%m/%y'),'%Y-%m-%d') as transaction_dateupdated
from sales_transaction;
Drop table sales_transaction;

RENAME TABLE sales_transaction_updated TO sales_transaction;

desc sales_transaction;

Select transaction_dateupdated as Datetrans, count(*) as transaction_count,
sum(quantitypurchased) as totalunitssold, sum(quantitypurchased*price) as totalsales
from sales_transaction
group by transaction_dateupdated
order by datetrans desc;

-- Question 11- Growth rate of sales
With cte as (
Select month(transaction_dateupdated) as month,
sum(quantitypurchased*price) as total_sales
from sales_transaction
group by month
)
Select month, total_sales,
lag(total_sales) over (order by month) as previous_month_sales,
(total_sales-lag(total_sales) over (order by month))*100/lag(total_sales) over (order by month)
as mom_growth_percentage
from cte
order by month ;

Select * from sales_transaction;


-- Question - High Purchase Frequency
Select CustomerID, count(*) as numberoftransactions,
sum(quantitypurchased*price) as Totalspent
from sales_transaction
group by customerID
having count(*)>10 and Totalspent>1000
Order by Totalspent desc;

-- Occassional customers
Select CustomerID, count(*) as numberoftransactions,
sum(quantitypurchased*price) as Totalspent
from sales_transaction
group by customerID
having count(*)<=2
Order by numberoftransactions asc, Totalspent desc;

-- Repeat Purchases

Select customerid, productid, count(*) as timespurchased
from sales_transaction
group by customerid, productid
order by timespurchased;


Select CustomerID, min(transaction_dateupdated) as firstpurchase
,max(transaction_dateupdated) as lastpurchase, datediff(max(transaction_dateupdated),min(transaction_dateupdated)) as Daysbetweenpurchases
from sales_transaction
group by customerID
having Daysbetweenpurchases>0
order by Daysbetweenpurchases desc;

-- Question- Customer Segmentation
Create table customer_segment as 
With quantity_purchased as
(
Select st.CustomerID, sum(st.quantitypurchased) as quantitypurchased
from customer_profiles as cp
join sales_transaction as st on cp.ï»¿CustomerID=st.CustomerID
group by st.customerID
)
Select customerID, case
when quantitypurchased between 1 and 10 then 'Low'
when quantitypurchased between 10 and 30 then 'Mid'
when quantitypurchased> 30 then 'High Value'
end as Customersegment
from quantity_purchased;
Select * from customer_segment;
Select customersegment, count(*)
from customer_segment
group by customersegment;


--Question 1- Removing Duplicates

Select ï»¿TransactionID, count(*) 
from sales_transaction
group by ï»¿TransactionID
having count(*)>1;

Create table sales_transaction_updates as
Select distinct * 
from sales_transaction;

Drop table sales_transaction;
Alter table sales_transaction_updates
rename to sales_transaction;
Select * from sales_transaction
where ï»¿TransactionID in (4999,5000)

--Question 2 - Fix Incorrect Price

Select st.ï»¿TransactionID, st.price as transactionprice, pi.price as Inventoryprice
from sales_transaction as st
join product_inventory as pi on st.ProductID=pi.ï»¿ProductID
where st.price<>pi.price;

Update sales_transaction as st
join product_inventory as pi on st.ProductID=pi.ï»¿ProductID
set st.price=pi.price
where st.price<>pi.price;


-- Question-3 Fixing Null Values

Select count(*) from customer_profiles
where count(*) is null;

Select * from customer_profiles;

-- Question 5 - Total sales summary

Select ProductID, sum(QuantityPurchased) as TotalUnitssold, sum(quantityPurchased*Price) as TotalSales
from sales_transaction
group by productid
order by totalsales desc;


# Find the customers who have never ordered anything yet.
select Name from Customers where Id NOT IN (select CustomerId from Orders);

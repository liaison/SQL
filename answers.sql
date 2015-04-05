
# Find the customers who have never ordered anything yet.
select Name FROM Customers
    WHERE Id NOT IN (select CustomerId FROM Orders);

# Works on Sqlite. Find the record with a raising temperature than its previous day.
SELECT Id FROM Weather AS W1
    WHERE EXISTS
        (SELECT * FROM Weather AS W2
            WHERE W2.Date = date(W1.Date, "-1 day")
              AND W2.Temperature < W1.Temperature);

# Solution on MySQL, with the date function DATE_SUB(date, unit)
SELECT Id FROM Weather AS W1
    WHERE EXISTS
        (SELECT * FROM Weather AS W2
            WHERE W2.Date = DATE_SUB(W1.Date, INTERVAL 1 DAY) 
            AND W2.Temperature < W1.Temperature);




# Find the customers who have never ordered anything yet.
SELECT Name FROM Customers
    WHERE Id NOT IN (SELECT CustomerId FROM Orders);

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


# Delete records with duplicate email address. Works for Sqlite.
DELETE FROM Person
    WHERE Id IN
    (SELECT P1.Id FROM Person AS P1, Person AS P2 
	    WHERE P1.Id > P2.Id AND P1.Email = P2.Email);

# Solution works for MySQL, but NOT Sqlite
DELETE P1 FROM Person P1, Person P2
    WHERE P1.Email = P2.Email and P1.Id > P2.Id;


# Second highest salary 
SELECT Salary FROM Employee
	WHERE Id IN 
	(SELECT Id FROM Employee ORDER BY Salary DESC LIMIT 2) 
	ORDER BY Salary LIMIT 1;


# MAX( all salary < MAX() )
SELECT MAX(Salary) FROM Employee 
    WHERE Salary < (SELECT MAX(Salary) FROM Employee);


# UNION SELECT NULL
SELECT * FROM 
	(SELECT `Salary` FROM `Employee` WHERE `Salary` != (SELECT MAX(`Salary`) FROM `Employee`) UNION SELECT NULL ) 
	AS `SecondHighestSalary` ORDER BY `Salary` DESC LIMIT 1;


# Ranking of scores
SELECT Q4.Score, Q3.Rank FROM
	(SELECT Q1.Score as Score, count(*) as Rank FROM
		(SELECT DISTINCT Score from Scores) AS Q1,
		(SELECT DISTINCT Score from Scores) AS Q2
	 WHERE Q1.Score <= Q2.Score GROUP BY Q1.Score) AS Q3, Scores AS Q4
WHERE Q4.Score=Q3.Score ORDER BY Q4.Score DESC;







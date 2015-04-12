# Find employee who earns more than their manager.
# Employee table:  Id, Name, Salary, ManagerId
SELECT E1.Name FROM Employee AS E1, Employee AS E2 WHERE E1.ManagerId = E2.Id AND E1.Salary > E2.Salary;

# Find the persons who earn the most in each department.
# Note: multiple persons could earn the same max salary in a department.
SELECT E.Name, E.Salary, D.Name FROM
    (SELECT MAX(Salary) AS MAX_SALARY, DepartmentId FROM Employee GROUP BY DepartmentId) AS Q1,
    Employee AS E, Department AS D
WHERE E.DepartmentId = Q1.DepartmentId AND E.Salary = Q1.MAX_SALARY AND D.Id = E.DepartmentId;


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

# With IFNULL(), LIMIT row_count OFFSET offset
SELECT IFNULL(
	(SELECT distinct Salary AS SecondHighestSalary FROM Employee ORDER BY Salary DESC LIMIT 1 OFFSET 1),
	NULL);

# IFNULL(), GROUP BY, LIMIT, OFFSET
SELECT IFNULL(
    (SELECT Salary FROM Employee GROUP BY Salary ORDER BY Salary DESC LIMIT 1 OFFSET 1),
    NULL);


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

# One can SELECT from the result set of another SELECT query, and rename the attribute name in the result set.
# One can see the result set from a SELECT query as a table.
# One can SELECT simultaneously from multiple tables/result set.
# To get the desired result, one refine the SELECT result with another SELECT and keep on refining/filtering/calculating until getting the final result.


# Select the Nth highest salary
SELECT Q3.Salary FROM
	(SELECT Q1.Salary, count(*) AS Rank FROM 
	  (SELECT Salary FROM Employee GROUP BY Salary) AS Q1,
	  (SELECT Salary FROM Employee GROUP BY Salary) AS Q2
	WHERE Q1.Salary <= Q2.Salary GROUP BY Q1.Salary) AS Q3
WHERE Q3.Rank=N

# With ORDER BY, LIMIT 1 OFFSET N
SET N=N-1;
SELECT DISTINCT Salary from Employee order by Salary DESC LIMIT 1 OFFSET 1;


# Two inners joins with the same tables
# A number that appears consecutively at least 3 times.
SELECT DISTINCT L1.Num FROM Logs AS L1, Logs AS L2, Logs AS L3
WHERE L2.Id = L1.Id + 1 AND L3.Id = L1.Id + 2 AND L1.Num = L2.Num AND L1.Num = L3.Num;





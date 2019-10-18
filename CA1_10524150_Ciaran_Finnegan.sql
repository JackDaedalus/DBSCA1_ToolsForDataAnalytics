/*	
	CA One - Tools for Data Analytics

	Student : - Ciaran Finnegan	
	Student No : - 10524150

	October 2019

	Part 2 : SQL Practical Assignment

*/



/* 
	-------------------------------------------------------------------------------------
	SQL QUERY ONE - Provide query and output : 10 columns for all sellers who sold 'Korean'
	cars in Eastern + Western United States after 2009.
	-------------------------------------------------------------------------------------
*/


/*	
	SQL DECLARATION OF VARIABLES
	
	To reduce the duplication of SQL code and avoid the explicit declaration of SQL selection
	criteria, I have declare a number of variables that are used across multiple SQL queries/subqueries
*/

/*	
	Declare variables to use in SQL queries to isolate the Korean cars after a given time.
	The '@Verified' variable is used to stored the literal 'Comments' value		
	
	These variables are used in both parts of the SQL CA			
*/
DECLARE @Selling_Date_After_2009 date, @Car_Category char(10), @Verified char(15)

/*	Assign variable values based on criteria details in the CA ONE brief */
SELECT @Selling_Date_After_2009 = '2009-12-31'
SELECT @Car_Category = 'Korean'
SELECT @Verified = 'Verified'


/*	For simplicity, we have set up a temporary table with the region id values for the
	required US regions. This avoided the need to repeat the full SQL in the nested SQL
	sub-queries in Part 1 and Part 2.												*/
DECLARE @RegionIDs TABLE (region_id INT)
INSERT INTO @RegionIDs SELECT region_id 
						FROM regions
						WHERE region in ('Eastern United States', 'Western United States')


/*	--------------------		PART ONE	-	SQL QUERY		-------------------	*/

/*	The majority of the information is read from the SQL sub-query below the initial SQL SELECT.
	It was necessary to use the this level of sub query to be able to reference the average
	price in the initial CASE statement. The average prie calculation is based on the 
	sub set of Korean, post 2009, US regional car data
*/
SELECT first_name, last_name, car, gender, region, selling_date, price, Avg_Price, 
	CASE
		WHEN  price > Avg_Price THEN 'Above Average'
		WHEN  price < Avg_Price THEN 'Below Average'
		ELSE 'Average'
	END Price_Label,
	Comment
FROM	/*	This subquery retrieves the data from the database tables using a join across the tables
			and nested sub queries. The Averge Price calaculation uses a correlated inner sub-query
			referencing the car details in the outter query */
		(SELECT S1.first_name, S1.last_name, S1.car, S1.gender, r.region, S1.selling_date, S1.price, 
					AVG(price) OVER (PARTITION BY s1.car)  Avg_Price,
					@Verified 'Comment'   /* The Comment field uses the literal value declared earlier in the script */
		FROM sellers S1, cars c, regions r
		WHERE S1.car = c.car
		/* The region join is included because I wanted to capture the test description of the region in the SELECT output */
		AND S1.region_id = r.region_id
		/* The SQL query used variables declared earlier in the script */
		AND c.category = @Car_Category
		AND S1.selling_date > @Selling_Date_After_2009
		AND S1.region_id IN (Select region_id from @RegionIDs)) A
ORDER BY car, price
/* avg(price) OVER (PARTITION BY s.car) Avg_Price  */



/* 
	---------------------------------------------------------------------------------------------------------
	SQL Query 2 - Using query in previous question, provide SQL to display output of Female and Male Sellers.
	---------------------------------------------------------------------------------------------------------

*/

/*	--------------------		PART TWO	-	SQL QUERY		-------------------	*/

/*	
	A Case statemet is used on the sub-query (taken from PArt One) to count the number of each specific
	gender and ensure that the output is on a single line, as required in the CA ONE brief.
*/
SELECT 
    sum(case when Gender = 'F' then 1 else 0 end) AS 'Female',
	sum(case when Gender = 'M' then 1 else 0 end) AS 'Male'
FROM 
	/*	This is a sligthly reduced verison of the query in Part One as we are focusing on Gender data */
	(SELECT s.first_name, s.last_name, s.car, s.gender as Gender, r.region, s.selling_date, s.price
	 FROM sellers s, cars c, regions r
	 WHERE s.car = c.car
	 AND s.region_id = r.region_id
	 AND c.category = @Car_Category
	 AND s.selling_date > @Selling_Date_After_2009
	 AND s.region_id IN (Select region_id from @RegionIDs)) B

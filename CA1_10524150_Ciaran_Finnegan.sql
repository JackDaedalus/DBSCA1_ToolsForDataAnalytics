/*	CA One - Tools for Data Analytics

	Student : - Ciaran Finnegan	
	Student No : - 10524150

	October 2019

	Part 2 : SQL Practical Assignment

*/



/* 

	SQL Query 1 - Provide query and output : 10 columns for all sellers who sold 'Korean'
	cars in Eastern + Western United States after 2009.

*/

SELECT s.first_name, s.last_name, s.car, s.gender, r.region, s.selling_date, s.price
FROM sellers s, cars c, regions r
WHERE s.car = c.car
AND s.region_id = r.region_id
AND c.category = 'Korean'
AND s.selling_date > '2009-12-31'
AND s.region_id in 
	(SELECT region_id FROM regions
	 WHERE region in ('Eastern United States', 'Western United States'))







/* 

	SQL Query 2 - Using query in previous question, provide SQL to display output of Female and Male Sellers.

*/

SELECT 
    sum(case when Gender = 'F' then 1 else 0 end) AS 'Female',
	sum(case when Gender = 'M' then 1 else 0 end) AS 'Male'
FROM 
	(SELECT s.first_name, s.last_name, s.car, s.gender as Gender, r.region, s.selling_date, s.price
	FROM sellers s, cars c, regions r
	WHERE s.car = c.car
	AND s.region_id = r.region_id
	AND c.category = 'Korean'
	AND s.selling_date > '2009-12-31'
	AND s.region_id in 
		(SELECT region_id FROM regions
		 WHERE region in ('Eastern United States', 'Western United States'))) A

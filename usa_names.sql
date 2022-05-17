-- csv file link :  https://drive.google.com/file/d/1OXR2A9uQeOYPvGI6P__qCifjgxgkhh1D/view?usp=sharing
-- Number of rows  :6,215,834
-- field names: state, gender, year, name, number

--create temporary table to sum up the numbers in the states group by gender and name
WITH tableA AS ( 
  SELECT name,gender,SUM(number) AS total 
  FROM `usa_names.usa_1910_current` 
  GROUP BY name, gender
  )
  
 --create temporary table to sum up the numbers in the states group by gender and name
WITH tableB AS ( 
  SELECT name,gender,state,SUM(number) AS total 
  FROM `usa_names.usa_1910_current` 
  GROUP BY name, gender,state
  ) 

--find the names that both men and women use
SELECT *
FROM tableA
WHERE name in
  (SELECT name
  FROM tableA
  GROUP BY name
  HAVING COUNT(name) = 2)
ORDER BY name


--find the 10 most popular male and females in the states
SELECT *
FROM
(SELECT *,row_number() OVER (PARTITION BY gender ORDER by tableA.total DESC) AS rn
FROM tableA)
WHERE rn <= 10

-find the 10 most popular male and female names in each state
SELECT *
FROM
(SELECT *,row_number() OVER (PARTITION BY gender,state ORDER by total DESC) AS rn
FROM tableB)
WHERE rn <= 10
ORDER BY state,gender



--find the names that used only by men
SELECT *
FROM tableA
WHERE name in
  (SELECT name
  FROM tableA
  GROUP BY name
  HAVING COUNT(name) = 1)
  AND gender = 'M'
  
--find the names that used only by women
SELECT *
FROM tableA
WHERE name in
  (SELECT name
  FROM tableA
  GROUP BY name
  HAVING COUNT(name) = 1)
  AND gender = 'F'

--find the names that are used by below 10 people
SELECT *
FROM tableA
WHERE total<10
ORDER BY total

--find the longest name
SELECT name,LENGTH(name) as len_name
FROM tableA
WHERE LENGTH(name) =
(SELECT MAX(LENGTH(name)) 
FROM tableA)

--find the shortest name
SELECT name,LENGTH(name) as len_name
FROM tableA
WHERE LENGTH(name) =
(SELECT MIN(LENGTH(name)) 
FROM tableA)

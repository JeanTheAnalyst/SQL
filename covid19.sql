---This dataset contains country-level datasets of daily time-series data related to COVID-19 globally. You can find the list of sources available here: https://github.com/open-covid-19/data 


---Aggregate the data by population, total_confirmed, total_deceased and fully_vaccianted 
WITH total AS
  (
    SELECT 
    country_name,MAX(population) AS population,
    MAX(cumulative_confirmed) AS total_confirmed,
    MAX(cumulative_deceased) AS total_deceased,
    MAX(cumulative_persons_fully_vaccinated) AS fully_vaccinated,
  
  FROM `covid19_open_data.covid19_open_data`
  WHERE location_key = country_code
  GROUP BY country_name)
  
  
 ---find the rate of infection by population in each country
SELECT country_name, total_confirmed, population, ROUND(total_confirmed / population *100,2)  AS rate_infection
FROM total
ORDER BY rate_infection DESC
 
---find the rate of death if someone is infected in each country
SELECT  country_name, total_confirmed, total_deceased, ROUND(total_deceased/total_confirmed*100,2) AS rate_death,
FROM total
WHERE total_confirmed > 0
ORDER BY rate_death DESC

---find the rate of full vaccination in each country
SELECT country_name, population,fully_vaccinated, ROUND(fully_vaccinated/population*100,2) AS rate_fully_vaccianted
FROM total
ORDER BY rate_fully_vaccianted DESC

---find the top 10 countries with most confirmed cases
SELECT country_name, total_confirmed
FROM total
ORDER BY total_confirmed DESC
LIMIT 10
 
 
 ---find the median of total_confirmed
 SELECT AVG(total_confirmed)
FROM 
(
  SELECT total_confirmed, row_number() OVER(ORDER BY total_confirmed) as rn1, row_number() OVER(ORDER BY total_confirmed DESC) as rn2
  FROM total
) as t
WHERE rn1=rn2 OR ABS(rn1-rn2) = 1

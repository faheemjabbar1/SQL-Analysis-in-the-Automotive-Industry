-- 🚗 Car Sales Analytics Dashboard
USE cars_info;


------------------------------------------------------------
-- 1. Dataset Overview
------------------------------------------------------------
SELECT
    COUNT(*) AS total_cars,
    COUNT(DISTINCT Name) AS unique_models,
    COUNT(DISTINCT fuel) AS fuel_types,
    COUNT(DISTINCT transmission) AS transmission_types,
    COUNT(DISTINCT seller_type) AS seller_types,
    ROUND(AVG(seats), 2) AS avg_seats,
    MIN(seats) AS min_seats,
    MAX(seats) AS max_seats,
    ROUND(AVG(year), 0) AS avg_year,
    MIN(year) AS oldest_car,
    MAX(year) AS newest_car
FROM car_info;

------------------------------------------------------------
-- 2. Price Statistics
------------------------------------------------------------
SELECT
    ROUND(AVG(selling_price), 2) AS avg_price,
    MIN(selling_price) AS cheapest_car_price,
    MAX(selling_price) AS most_expensive_car_price
FROM car_info;

-- Best & worst performing cars
SELECT Name, selling_price
FROM car_info
ORDER BY selling_price DESC
LIMIT 1;

SELECT Name, selling_price
FROM car_info
ORDER BY selling_price ASC
LIMIT 1;

------------------------------------------------------------
-- 3. Price Comparisons
------------------------------------------------------------
-- By fuel type
SELECT fuel, ROUND(AVG(selling_price), 2) AS avg_price
FROM car_info
GROUP BY fuel
ORDER BY avg_price DESC;

-- By transmission
SELECT transmission, ROUND(AVG(selling_price), 2) AS avg_price
FROM car_info
GROUP BY transmission;

-- Within ±10% of market average
SELECT Name, selling_price
FROM car_info
WHERE selling_price BETWEEN 
      (SELECT AVG(selling_price) * 0.9 FROM car_info)
      AND (SELECT AVG(selling_price) * 1.1 FROM car_info)
	  LIMIT 10;

------------------------------------------------------------
-- 4. Performance Metrics
------------------------------------------------------------
-- Highest mileage cars (top 5)
SELECT Name,
       AVG(CAST(REPLACE(mileage, ' kmpl', '') AS DECIMAL(10,2))) AS avg_mileage
FROM car_info
WHERE mileage REGEXP '^[0-9]+'
GROUP BY Name
ORDER BY avg_mileage DESC
LIMIT 5;

-- Most km driven cars (top 5 workhorses)
SELECT Name, SUM(km_driven) AS total_km
FROM car_info
GROUP BY Name
ORDER BY total_km DESC
LIMIT 5;

------------------------------------------------------------
-- 5. Trends & Variability
------------------------------------------------------------
-- Top 10 Cars with decreasing price year-to-year
SELECT Name, year, selling_price, previous_price
FROM (
    SELECT Name, year, selling_price,
           LAG(selling_price) OVER (PARTITION BY Name ORDER BY year) AS previous_price
    FROM car_info
) t
WHERE selling_price < previous_price LIMIT 10;

-- Top 10 Best sellers each year (highest avg selling price)
SELECT year, Name, ROUND(AVG(selling_price), 2) AS avg_price
FROM car_info
GROUP BY year, Name
HAVING AVG(selling_price) = (
    SELECT MAX(avg_price)
    FROM (
        SELECT year, Name, ROUND(AVG(selling_price), 2) AS avg_price
        FROM car_info
        GROUP BY year, Name
    ) sub
    WHERE sub.year = car_info.year) LIMIT 10;

-- Top 3 most stable cars (lowest price variation)
SELECT Name,
       MAX(selling_price) - MIN(selling_price) AS price_range
FROM car_info
GROUP BY Name
ORDER BY price_range ASC
LIMIT 3;

------------------------------------------------------------
-- 6. Advanced Analytics
------------------------------------------------------------
-- Average selling price for manual first-owner cars, by fuel
SELECT fuel, AVG(selling_price) AS avg_selling_price
FROM car_info
WHERE transmission = 'Manual' AND owner = 'First Owner'
GROUP BY fuel;

-- Top 3 models with highest mileage (cars with >5 seats)
SELECT Name, AVG(CAST(REPLACE(mileage, ' kmpl', '') AS DECIMAL(10,2))) AS avg_mileage
FROM car_info
WHERE seats > 5 AND mileage IS NOT NULL
GROUP BY Name
ORDER BY avg_mileage DESC
LIMIT 3;

-- Models with price variation > 10,000
SELECT Name
FROM car_info
GROUP BY Name
HAVING MAX(selling_price) - MIN(selling_price) > 10000 LIMIT 10;

-- Top 10 Cars above avg price but below avg mileage
SELECT Name
FROM car_info
WHERE selling_price > (SELECT AVG(selling_price) FROM car_info)
  AND CAST(REPLACE(mileage, ' kmpl', '') AS DECIMAL(10,2)) <
      (SELECT AVG(CAST(REPLACE(mileage, ' kmpl', '') AS DECIMAL(10,2))) FROM car_info) limit 10;

-- Cumulative sales value per car by year (top 50 Cars)
SELECT DISTINCT Name, year, selling_price,
       SUM(selling_price) OVER (PARTITION BY Name ORDER BY year) AS cumulative_sum
FROM car_info limit 50 ;

-- Cars with highest mileage per transmission type
WITH TotalMileage AS (
    SELECT Name, transmission, SUM(km_driven) AS total_mileage
    FROM car_info
    GROUP BY Name, transmission
)
SELECT Name, transmission, total_mileage
FROM TotalMileage
WHERE (transmission, total_mileage) IN (
    SELECT transmission, MAX(total_mileage)
    FROM TotalMileage
    GROUP BY transmission
);

-- Avg selling price per year for top 3 models (highest overall sales)
WITH TopCars AS (
    SELECT Name
    FROM car_info
    GROUP BY Name
    ORDER BY SUM(selling_price) DESC
    LIMIT 3
)
SELECT Name, year, AVG(selling_price) AS avg_selling_price_per_year
FROM car_info
WHERE Name IN (SELECT Name FROM TopCars)
GROUP BY Name, year
ORDER BY Name, year;

-- ==========================================================================================
--                                WORK WITH WORLD
-- ==========================================================================================

-- 1. Display Name, Continent and Popoulation of all countries in Asia.
SELECT Name, Continent, Population
FROM Country
WHERE Continent = 'Asia';

-- ==========================================================================================

-- 2. Display Name, Population and Life Expectency of all countries.
--    Sort population in descending order.
SELECT  Name, Population, LifeExpectancy
FROM country
ORDER BY Population DESC;

-- ===========================================================================================

-- 3. Display the Name, Continent and Population of countries that belong to Europe, 
--    AND have a popolation greater than 20,00,000 
--    Sort the result alphabetically by country name.
SELECT  Name, Continent, Population
FROM Country
WHERE Continent = 'Europe'
	AND Population > 2000000
ORDER BY Name ASC;

-- ===========================================================================================

-- 4. Display the Name, Region and surface area of countries that are located in
--    Europe, North America OR South America
--    Sort by region
SELECT Name, Region, SurfaceArea
FROM Country
WHERE Continent = 'Europe'
   OR Continent = 'North America' 
   OR Continent ='South America'
ORDER BY Region ASC;

-- ===========================================================================================

-- 5. Display the Name, Continent and Population of all countries that are NOT located in Africa. 
--    Sort the results by country name. 
SELECT Name, Continent, Population
FROM Country
WHERE Continent != 'Africa'
ORDER BY Name;

-- ===========================================================================================

-- 6. Display the Name, Population and GovernmentForm of countries 
--    whose population 10,00,000 and 50,00,000
--    Sort the results by population
SELECT Name, Population, GovernmentForm
FROM Country
WHERE Population BETWEEN 1000000 AND 5000000
ORDER BY Population ASC;

-- ===========================================================================================

-- 7. Display the Name, Capital and population of countries
--    whose continent is one of the following: Asia, Europe, Oceania
--    Sort the results by population.
SELECT c.Name, ci.Name AS Capital, c.Population
FROM Country c, City ci
WHERE c.Capital = ci.ID
	and Continent IN ('Asia','Europe','Oceania')
ORDER BY Population ASC;

-- ============================================================================================

-- 8. Display the Name, Region and population of countries 
--    whose name starts with  letter 'A'
--    Sort the results alphabetically.
SELECT Name, Region, Population
FROM Country
WHERE Name LIKE 'A%'
ORDER BY Name ASC;

-- ============================================================================================

-- 9. Display Name, continent, Population and Life Expectency of all countries that are
--    in Asia OR Europe,
--    Have a population greater than 50,00,000
--    AND have a life expectancy greater than 70.
--    Sort the results by population in descending order.
SELECT Name, continent, Population, LifeExpectancy
FROM Country
WHERE Continent IN ('Asia' , 'Europe')
	AND Population > 5000000
    AND LifeExpectancy > 70
ORDER BY Population DESC;

-- ============================================================================================

-- 10.  Display Name, continent, Population and Government form of all countries that are
--    NOT in Africa,
--    Have a population between 5,00,000 than 30,00,000
--    AND whose names contain the letter 'land'.
--    Sort the results alphabetically.
SELECT Name, continent, Population, GovernmentForm
FROM Country
WHERE Continent != 'Africa' 
	AND Population BETWEEN 500000 AND 3000000
	AND Name LIKE '%land%'
ORDER BY Name;

-- =============================================================================================
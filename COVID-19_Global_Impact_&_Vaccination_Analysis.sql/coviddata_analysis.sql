--                  ===========================================================
--                                COVID-19 DATA EXPLORATION PROJECT
--                  ===========================================================
-- 

-- =========================================================
-- DATA EXPLORATION
-- =========================================================

-- Preview COVID Death Statistics
-- =========================================================

SELECT *
FROM Covid_Deaths
ORDER BY location, dates;

-- Preview COVID Vaccination Statistics
-- =========================================================

SELECT *
FROM Covid_Vaccinations
ORDER BY location, dates;

-- Select Key Indicators
-- =========================================================

SELECT
    location,
    dates,
    population,
    total_cases,
    new_cases,
    total_deaths
FROM Covid_Deaths
ORDER BY location, dates;

-- =========================================================
-- MORTALITY ANALYSIS
-- =========================================================

-- Global Case Fatality Rate
-- =========================================================

SELECT
    MAX(total_cases) AS Total_Cases,
    MAX(total_deaths) AS Total_Deaths,
    ROUND(
        MAX(total_deaths) * 100 /
        NULLIF(MAX(total_cases),0),
        2
    ) AS Death_Percentage
FROM Covid_Deaths
WHERE continent <> '';

--    • India Case Fatality Rate
-- =========================================================

SELECT
    location,
    dates,
    population,
    total_cases,
    total_deaths,
    ROUND(
        total_deaths * 100 /
        NULLIF(total_cases,0),
        2
    ) AS Death_Percentage
FROM Covid_Deaths
WHERE location LIKE '%India%'
AND continent <> ''
ORDER BY dates;

-- Countries with Highest Mortality Rate
-- =========================================================

SELECT
    location,
    population,
    MAX(total_deaths) AS Total_Deaths,
    ROUND(
        MAX(total_deaths) * 100 / population,
        2
    ) AS Death_Rate_Percentage
FROM Covid_Deaths
WHERE continent <> ''
GROUP BY location, population
ORDER BY Death_Rate_Percentage DESC;

-- Continents with Highest Death Count
-- =========================================================

SELECT
    continent,
    MAX(total_deaths) AS Total_Deaths
FROM Covid_Deaths
WHERE continent <> ''
GROUP BY continent
ORDER BY Total_Deaths DESC;

-- Countries with Highest Death Count
-- =========================================================

SELECT
    location,
    MAX(total_deaths) AS Total_Deaths
FROM Covid_Deaths
WHERE continent <> ''
GROUP BY location
ORDER BY Total_Deaths DESC;

-- =========================================================
-- INFECTION ANALYSIS
-- =========================================================

-- Countries with Highest Infection Rate
-- =========================================================

SELECT
	location,
	population,
	MAX(total_cases) AS Total_Cases,
	ROUND(
		MAX(total_cases) * 100 / population,
		2
	) AS Infection_Rate_Percentage
FROM Covid_Deaths
WHERE continent <> ''
GROUP BY location, population
ORDER BY Infection_Rate_Percentage DESC;
  
-- Top 10 Countries by Confirmed Cases
-- =========================================================
  
SELECT 
	location, 
	MAX(total_cases) Top_total_cases
FROM covid_deaths
WHERE continent <> '' 
GROUP BY location
ORDER BY Top_total_cases DESC
LIMIT 10;

-- Countries with Lowest Infection Count
-- =========================================================
    
SELECT 
	location,
    MAX(total_cases) Lowest_cases
FROM covid_deaths
WHERE continent <> '' AND  total_cases != 0
GROUP BY location
ORDER BY Lowest_cases ASC;

-- Daily Global New Cases
-- =========================================================

SELECT 
	dates, 
    SUM(new_cases)
FROM covid_deaths
WHERE continent <> '' 
GROUP BY dates
ORDER BY dates;

-- Monthly Global Case Trend
-- =========================================================

SELECT 
	DATE_FORMAT(dates,'%M,%Y') Monthly,
    MAX(new_cases)
FROM covid_deaths
WHERE continent <> '' 
GROUP BY YEAR(dates),
	MONTH(dates),
    DATE_FORMAT(dates,'%M,%Y') 
ORDER BY YEAR(dates),
	MONTH(dates);    

-- =========================================================
-- VACCINATION ANALYSIS
-- =========================================================

-- Create Integrated COVID View
-- =========================================================

CREATE VIEW coviddata AS 
	SELECT 
		CD.continent,
        CD.location,
        CD.dates,
        CD.population,
        CV.people_vaccinated,
        CV.new_vaccinations
	FROM covid_deaths AS CD
	JOIN covid_vaccinations AS CV
	ON CD.location = CV.location
    AND CD.dates = CV.dates
    WHERE CD.continent <> '';
    
SELECT *
FROM coviddata;

-- Vaccination Coverage by Continent
-- =========================================================

SELECT 
	continent,
    MAX(population) Total_populations,
	MAX(people_vaccinated) Total_vaccinations, 
	ROUND(
		MAX(people_vaccinated)* 100 /
        MAX(population),
        2
	   ) AS Vaccination_percent
FROM coviddata
WHERE continent <> '' 
GROUP BY continent
ORDER BY Vaccination_percent DESC;

-- Vaccination Coverage by Country
-- =========================================================

SELECT
    location,
    MAX(population) AS Total_Population,
    MAX(people_vaccinated) AS People_Vaccinated,
    ROUND(
        MAX(people_vaccinated) * 100 /
        MAX(population),
        2
    ) AS Vaccination_Percentage
FROM CovidData
WHERE continent <> '' 
GROUP BY location
ORDER BY Vaccination_Percentage DESC;

-- Rolling Vaccination Progress
-- =========================================================

SELECT
    location,
    dates,
    population,
    new_vaccinations,
    SUM(new_vaccinations)
    OVER(
        PARTITION BY location
        ORDER BY dates
    ) AS Rolling_Vaccinations
FROM CovidData;

-- =========================================================
-- ADVANCED ANALYSIS
-- =========================================================

-- Highest Single-Day Case Count
-- =========================================================

SELECT dates,
	MAX(new_cases) Highest_case_in_a_day
FROM covid_deaths
WHERE continent <> '' 
GROUP BY dates
ORDER BY Highest_case_in_a_day DESC
LIMIT 1;

-- First Date Countries Crossed 100K Cases
-- =========================================================

SELECT 
	location,
	MIN(dates) First_100k_countries
FROM covid_deaths
WHERE continent <> ''
	AND total_cases >= 100000
GROUP BY location
ORDER BY First_100k_countries;

-- Seven-Day Moving Average
-- =========================================================

SELECT
    location,
    dates,
    new_cases,
    ROUND(
        AVG(new_cases)
        OVER(
            PARTITION BY location
            ORDER BY dates
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2)
            AS Moving_Average_7_Days
FROM Covid_Deaths
WHERE continent <> '';

-- Previous Day Case Comparison (LAG)
-- =========================================================

SELECT 
	dates,
    location,
	new_cases,
	LAG(new_cases) OVER( PARTITION BY location ORDER BY dates) 
    AS Previous_day_cases
FROM covid_deaths
WHERE continent <> ''
ORDER BY location;

-- Month-over-Month Growth
-- =========================================================
SELECT 
	DATE_FORMAT(dates,'%M,%Y') AS Months,
    location,
	MAX(new_cases) AS Total_cases
FROM covid_deaths
WHERE continent <> ''
GROUP BY YEAR(dates),MONTH(dates),
    location,
    DATE_FORMAT(dates,'%M,%Y')
ORDER BY 	
	location,
    YEAR(dates),
    MONTH(dates);

-- Highest Vaccination Rate
-- =========================================================

SELECT 
	location,
	population,
	MAX(people_vaccinated) * 100/
     population AS Vaccination_rate
FROM coviddata
GROUP BY location,population;

-- Dashboard Summary
-- =========================================================
SELECT CD.continent,
	CD.location,
    MONTH(CD.dates),
    MAX(CD.total_cases),
    MAX(CD.total_deaths),
    MAX(CV.new_vaccinations),
    MAX(CV.people_vaccinated)
FROM covid_deaths AS CD
JOIN covid_vaccinations AS CV
ON CD.continent = CV.continent
	AND CD.location = CV.location
WHERE CD.continent <> ''
GROUP BY CD.continent,
	CD.location,
    MONTH(CD.dates);
 
 
 --  =========================================================
-- CONCLUSION / KEY INFERENCES
-- =========================================================
--
-- 1. Mortality
--    - Global case fatality rate stayed low relative to total infections,
--      but varied widely by country when normalized against population,
--      highlighting differences in healthcare capacity and reporting.
--    - A small set of countries account for a disproportionate share of
--      total global deaths, concentrating the pandemic's mortality impact.
--
-- 2. Infection Spread
--    - Infection rate as a percentage of population varied sharply across
--      countries, showing the pandemic did not spread uniformly and was
--      shaped by factors like density, mobility, and containment measures.
--    - Daily and monthly case trends reveal distinct waves rather than a
--      single continuous rise, useful for correlating with policy or
--      variant timelines.
--
-- 3. Vaccination Progress
--    - Vaccination coverage by continent/country was uneven, with some
--      regions reaching high population coverage much earlier than others,
--      pointing to global disparities in vaccine access and rollout speed.
--    - The rolling vaccination total (window function) shows cumulative
--      progress over time and can flag where rollout stalled or accelerated.
--
-- 4. Methodology Notes
--    - NULLIF was used throughout to guard against divide-by-zero errors
--      when calculating percentages (e.g., death/vaccination rates).
--    - A reusable VIEW (coviddata) was created to simplify repeated joins
--      between the deaths and vaccinations tables.
--    - Window functions (SUM() OVER, AVG() OVER, LAG()) enabled rolling
--      totals, 7-day moving averages, and day-over-day comparisons without
--      collapsing the row-level detail needed for time-series analysis.
--
-- Overall, this analysis moves from basic exploration to time-series and
-- comparative insights, demonstrating that pandemic outcomes (deaths,
-- infections, and vaccination coverage) were highly uneven across
-- countries and continents, rather than following a single global pattern.
-- =========================================================
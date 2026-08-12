# COVID-19 Global Impact & Vaccination Analysis (SQL)

## Business Problem
During a global pandemic, decision-makers (health authorities, policymakers, analysts) need to understand **where the virus hit hardest, how it spread over time, and how vaccination rollout compared across regions** — to evaluate healthcare response, identify disparities in vaccine access, and inform future pandemic preparedness. This project uses SQL to explore and analyze COVID-19 case, death, and vaccination data to surface those patterns.

## About the Data
- **Tables:**
  - `Covid_Deaths` — location, date, population, total/new cases, total/new deaths (by country/continent, over time)
  - `Covid_Vaccinations` — location, date, people vaccinated, new vaccinations
- A `coviddata` **view** was created by joining the two tables on `location` and `dates` to simplify repeated vaccination-related queries.
- Rows filtered to `continent <> ''` throughout, to exclude aggregate/region-level rows (e.g. "World", "Asia") and keep the analysis at the country level.

## Analysis Performed
The SQL script progresses from basic exploration to advanced time-series analysis, organized into four sections:

**1. Data Exploration** — previewed both tables and selected key indicators (location, dates, population, cases, deaths).

**2. Mortality Analysis**
- Global case fatality rate (total deaths ÷ total cases).
- India-specific fatality rate over time.
- Countries ranked by death rate as % of population.
- Continents and countries ranked by total death count.

**3. Infection Analysis**
- Countries ranked by infection rate (% of population infected).
- Top 10 countries by confirmed cases; countries with lowest case counts.
- Daily global new cases and monthly case trend (using `DATE_FORMAT`, `GROUP BY YEAR/MONTH`).

**4. Vaccination Analysis**
- Vaccination coverage by continent and by country (% of population vaccinated).
- Rolling vaccination totals using a **window function** (`SUM() OVER (PARTITION BY location ORDER BY dates)`).

**5. Advanced Analysis**
- Highest single-day global case count.
- First date each country crossed 100,000 total cases.
- 7-day moving average of new cases (`AVG() OVER (... ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)`).
- Day-over-day case comparison using `LAG()`.
- Month-over-month case growth by country.
- Combined dashboard-style summary joining deaths and vaccinations by continent/location/month.

## Key Results
- **Mortality:** The global case fatality rate stayed relatively low against total infections, but varied widely by country once normalized by population — pointing to differences in healthcare capacity and reporting quality. A small set of countries accounted for a disproportionate share of total global deaths.
- **Infection spread:** Infection rate as a % of population varied sharply by country, showing the pandemic spread unevenly, likely shaped by density, mobility, and containment measures. Daily/monthly trends revealed distinct waves rather than one continuous rise.
- **Vaccination progress:** Vaccination coverage was uneven across continents and countries, with some regions reaching high coverage much earlier than others — highlighting global disparities in vaccine access and rollout speed. The rolling vaccination totals help identify where rollout stalled or accelerated.

## Next Steps
- Visualize the query outputs (e.g. in Tableau, Power BI, or Python) to make trends like the 7-day moving average and rolling vaccinations easier to communicate.
- Correlate infection/death waves with known policy interventions or variant emergence dates.
- Normalize vaccination and death comparisons by additional factors (e.g. median age, GDP, healthcare spend per capita) to explain *why* disparities exist, not just where.
- Automate the `coviddata` view and key queries into a recurring reporting pipeline (stored procedures or a scheduled job) for updated data.
- Add indexes on `location` and `dates` if working with the full-size dataset, since most queries filter/join/partition on these columns.

## Problems Faced
- **Divide-by-zero risk in percentage calculations:** death rate and vaccination rate formulas divide by `total_cases` or `population`, which could be zero or null — handled using `NULLIF()` to avoid SQL errors.
- **Excluding aggregate rows:** the raw data includes non-country rows (continents, "World", income groupings) with a blank `continent` field, which had to be filtered out (`continent <> ''`) in every query to avoid double-counting or skewing country-level rankings.
- **Repeated joins:** several vaccination queries needed the same `Covid_Deaths` + `Covid_Vaccinations` join — solved by creating a reusable `coviddata` VIEW instead of repeating the join logic in every query.
- **Window function complexity:** calculating rolling vaccination totals, 7-day moving averages, and day-over-day comparisons required careful use of `PARTITION BY` and `ORDER BY` within window functions to avoid mixing data across different countries.
- **Date-based grouping:** monthly trend and month-over-month growth queries required grouping by both `YEAR(dates)` and `MONTH(dates)` (in addition to the formatted label) to sort chronologically rather than alphabetically by month name.

## Tools Used
SQL (MySQL syntax — `DATE_FORMAT`, window functions, views)

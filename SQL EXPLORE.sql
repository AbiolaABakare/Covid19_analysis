/*
Covid 19 Data Exploration

Skills used: Joins, CTE'S, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

SELECT *
FROM SQLPortfolioProject.dbo.coviddeath
WHERE continent is not null
ORDER BY 3,4


-- Select Data that we are going to be starting with

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM SQLPortfolioProject.DBO.coviddeath
WHERE continent is not null
ORDER BY 1,2


-- Total Cases VS Total Deaths
-- Shows likelihood of dying if you contract Covid in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
FROM SQLPortfolioProject..coviddeath
WHERE location like '%state%' and continent is not null
ORDER BY 1,2


--  Total Cases VS Population
--  Shows what percentage of population infected with Covid

SELECT location, date, population, total_cases, (total_cases/population)*100 as "InfectedPopulation %"
FROM SQLPortfolioProject..coviddeath
WHERE location like '%state%'
ORDER BY 1,2


--  Countries with Highest Infection Rate compared to Population

SELECT location, population, max(total_cases) as Highest_InfectionCount,
max(total_cases/population)*100 as "Population_Infected %"
FROM SQLPortfolioProject..coviddeath
GROUP BY location, population
ORDER BY "Population_Infected %" desc

--  Countries with Highest Death Count per Population

SELECT location, max(cast(total_deaths as int)) as "Total_Death #" 
FROM SQLPortfolioProject..coviddeath
WHERE continent is not null
GROUP BY location
ORDER BY "Total_Death #" desc


--  BREAKING THINGS DOWN BY CONTINENT

--  Showing continent with the highest death count per population

SELECT continent, max(cast(total_deaths as int)) as "Total_Death #"     -- you can also change continent to location to get more interesting results
FROM SQLPortfolioProject..coviddeath
WHERE continent is not null
GROUP BY continent
ORDER BY "Total_Death #" desc  



--      GLOBAL NUMBERS

SELECT date, SUM(new_cases) as total_cases, 
SUM(cast(new_deaths as int)) as total_deaths, 
SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as "Death %"
FROM SQLPortfolioProject..coviddeath
WHERE continent is not null
GROUP BY date
ORDER BY 1,2




--   Total Population VS Vaccination
--   Shows Percentage of Population that has received at least one Covid vaccine

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(convert(int, vac.new_vaccinations)) 
OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingCountVaccinated
--,(RollingCountVaccinated/population)*100
FROM SQLPortfolioProject..coviddeath dea
JOIN SQLPortfolioProject..CovidsVacinations vac
		ON dea.location = vac.location
		and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3


--   Using CTE to perform calculation on Partition By in previous query


With PopVsVac (Continent, Location, Date, Population, New_vaccination, RollingCountVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(convert(int, vac.new_vaccinations)) 
OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingCountVaccinated
--,(RollingCountVaccinated/population)*100
FROM SQLPortfolioProject..coviddeath dea
JOIN SQLPortfolioProject..CovidsVacinations vac
		ON dea.location = vac.location
		and dea.date = vac.date
WHERE dea.continent is not null
)

Select *, (RollingCountVaccinated/Population)*100  "% of Vaccinated"
FROM PopVsVac


-- Using Temp Table to Perform Calculation on Partition By in previous Query

Drop Table if exists #VaccinatedPopulationPercentage
Create Table #VaccinatedPopulationPercentage
(
continent  nvarchar(255),
location  nvarchar(255),
date  datetime,
population  numeric,
new_vaccinations  numeric,
RollingCountVaccinated  numeric
)


Insert into #VaccinatedPopulationPercentage
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) 
OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingCountVaccinated
FROM SQLPortfolioProject..coviddeath dea
JOIN SQLPortfolioProject..CovidsVacinations vac
		ON dea.location = vac.location
		and dea.date = vac.date
WHERE dea.continent is not null


Select *, (RollingCountVaccinated/Population)*100  "% of Vaccinated"
FROM #VaccinatedPopulationPercentage


-- Creating View to Store Data for Later Visualization

Create View VaccincatedPopulationPercent as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) 
OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingCountVaccinated
FROM SQLPortfolioProject..coviddeath dea
JOIN SQLPortfolioProject..CovidsVacinations vac
		ON dea.location = vac.location
		and dea.date = vac.date
WHERE dea.continent is not null
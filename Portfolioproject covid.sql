SELECT *
From Portfolioproject.dbo.CovidDeaths
Where continent is not NULL
order by 3,4

SELECT *
From Portfolioproject.dbo.CovidVaccinations
Where continent is not NULL
order by 3,4

SELECT location , date ,total_cases, new_cases, total_deaths , population
From Portfolioproject.dbo.CovidDeaths
Where continent is not NULL
order by 1,2


SELECT location , date ,total_cases, total_deaths , (total_deaths/total_cases)*100  as DeathPercentage
From Portfolioproject.dbo.CovidDeaths
where location like '%India%'
order by 1,2

SELECT location , date ,total_cases, population , (total_cases/population)*100  as CasePercentage
From Portfolioproject.dbo.CovidDeaths
where location like '%India%'
order by 1,2

--looking at countries having highest infection rate compare to population

SELECT location , MAX(total_cases) as HighestInfectionCount , MAX((total_cases/population))*100  as CasePercentage
From Portfolioproject.dbo.CovidDeaths
Where continent is not NULL
Group by   location , population
order by CasePercentage desc

-- countries with highest death counts
SELECT location , MAX(cast(total_deaths as int)) as TotalDeathCounts
From Portfolioproject.dbo.CovidDeaths
Where continent is not NULL
Group by   location , population
order by TotalDeathCounts desc

-- by continent

SELECT location , MAX(cast(total_deaths as int)) as TotalDeathCounts
From Portfolioproject.dbo.CovidDeaths
Where continent is NULL
Group by location
order by TotalDeathCounts desc


-- Global Numbers
SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths , SUM(cast(new_deaths as int))/SUM(new_cases)*100  as DeathPercentage
From Portfolioproject.dbo.CovidDeaths
where continent is not NULL
order by 1,2



SELECT dea.continent, dea.location , dea.date , dea.population , vac.new_vaccinations ,
SUM(CONVERT(int , vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location , dea.date) as PeopleVaccinated 
from Portfolioproject.dbo.CovidDeaths dea
Join Portfolioproject.dbo.CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not NULL
order by 2,3
    
-- Use CTE

With PopvsVac (Continent , location , date , population , New_vaccinations , PeopleVaccinated)
as
(
SELECT dea.continent, dea.location , dea.date , dea.population , vac.new_vaccinations ,
SUM(CONVERT(int , vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location , dea.date) as PeopleVaccinated 
from Portfolioproject.dbo.CovidDeaths dea
Join Portfolioproject.dbo.CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not NULL
--order by 2,3 
)
Select * , (PeopleVaccinated / population)*100
from PopvsVac 
order by 2 , 3


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 



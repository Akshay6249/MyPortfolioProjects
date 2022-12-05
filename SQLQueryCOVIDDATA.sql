SELECT *
FROM PortfolioProjects..CovidDeaths$ 
where continent is not null
order by 3,4


----select *
----from PortfolioProjects..CovidVaccinations$
----order by 3,4

---Select Data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProjects..CovidDeaths$ 
order by 1,2

---Looking at total cases vs total Deaths
---Shows Likehood of dying if you contact covid in your country

SELECT location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as Death_Percentage
FROM PortfolioProjects..CovidDeaths$ 
where location like '%India%'
order by 1,2 

--Looking at the total case vs population
--Shows what percentage of population got covid

SELECT location, date, total_cases, population,(total_deaths/population)*100 as Death_Percentage
FROM PortfolioProjects..CovidDeaths$ 
where location like '%India%'
order by 1,2 


--Looking at countries with higest infection rate

SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population) as Death_Percentage
FROM PortfolioProjects..CovidDeaths$ 
--where location like '%India%'
Group by location, population
order by  Death_Percentage desc

---Showing countries with highest Death count per population

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathcount
FROM PortfolioProjects..CovidDeaths$ 
--where location like '%India%'(edited)
where continent is not null
Group by location
order by  TotalDeathcount desc


---Showing continent wise

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathcount
FROM PortfolioProjects..CovidDeaths$ 
--where location like '%India%'(edited)
where continent is null
Group by location
order by  TotalDeathcount desc


---Showing the continent with the higest death count per population

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathcount
FROM PortfolioProjects..CovidDeaths$ 
--where location like '%India%'(edited)
where continent is not null
Group by continent
order by  TotalDeathcount desc

---GLOBAL NUMBERS--

SELECT  SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/ SUM (New_Cases)*100 as Death_Percentage
FROM PortfolioProjects..CovidDeaths$ 
--where location like '%India%' (need to look more into this)
WHERE continent is not null
--Group by date
order by 1,2 


---joinig table---
---Looking at total population vs vacinations
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
from PortfolioProjects..CovidDeaths$ dea
join PortfolioProjects..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 1,2


---joined table---
---Looking at total population vs vacinations deep
--This quary was has an error int, sol;int tobig int

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location)
from PortfolioProjects..CovidDeaths$ dea
join PortfolioProjects..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 1,2


---joined table---
---Looking at total population vs vacinations deep	(2)
--

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjects..CovidDeaths$ dea
Join PortfolioProjects..CovidVaccinations$ vac
	On dea.location = vac.location

	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


--USE CTE
 --for divide

--look again


WITH PopvsVac (Continent, Location ,Date, Population,new_vaccinations,RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjects..CovidDeaths$ dea
Join PortfolioProjects..CovidVaccinations$ vac
	On dea.location = vac.location

	and dea.date = vac.date
where dea.continent is not null )
--order by 2,3
Select *, 
(RollingPeopleVaccinated/Population)*100
From PopvsVac

--Temp table

CREATE TABLE #PercentPopulationVaccinated

(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric)
 
 Insert into #PercentPopulationVaccinated
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjects..CovidDeaths$ dea
Join PortfolioProjects..CovidVaccinations$ vac
	On dea.location = vac.location

	and dea.date = vac.date
where dea.continent is not null 
order by 2,3
Select *, 
(RollingPeopleVaccinated/Population)*100
From  #PercentPopulationVaccinated



--IF need to modify data (same 2)
--HIGLY RECOMND
--ALTR

DROP TABLE IF exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated

(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric)
 
 Insert into #PercentPopulationVaccinated
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjects..CovidDeaths$ dea
Join PortfolioProjects..CovidVaccinations$ vac
	On dea.location = vac.location

	and dea.date = vac.date
where dea.continent is not null 
order by 2,3
Select *, 
(RollingPeopleVaccinated/Population)*100
From  #PercentPopulationVaccinated


--CREATING VIEWS
--TO STORE DATA FOR VISUL

CREATE VIEW PercentPopulationVaccinated01 as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date)
as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjects..CovidDeaths$ dea
Join PortfolioProjects..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

select * from PercentPopulationVaccinated01
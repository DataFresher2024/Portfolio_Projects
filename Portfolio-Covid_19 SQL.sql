Select *
From PortfolioProject..Covid_Deaths
Where continent is not null
Order by 3,4

--Select *
--From PortfolioProject..Covid_Vaccinations
--Order by 3,4

Select Location, Date, total_cases, new_cases, total_deaths, population
From PortfolioProject..Covid_Deaths
Order by 1,2


-- Looking at Total Cases vs Total Deaths

Select Location, Date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage 
From PortfolioProject..Covid_Deaths
Where location like '%Afghanistan%' 
Order by 1,2


-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid


Select Location, Date, total_cases, population, (total_cases/population)*100 as DeathPercentage 
From PortfolioProject..Covid_Deaths
Where location like '%Afghanistan%' 
Order by 1,2


-- Looking at Countries with Highest Infection Rate compared to Population

Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected 
From PortfolioProject..Covid_Deaths
--Where location like '%Afghanistan%' 
Group by Location, population 
Order by PercentPopulationInfected desc


-- Showing Countries with Highest Death Count per Population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount 
From PortfolioProject..Covid_Deaths
--Where location like '%Afghanistan%'
Where continent is not null
Group by location
Order by TotalDeathCount desc


-- Showing continents with the highest death count per population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount 
From PortfolioProject..Covid_Deaths
--Where location like '%Afghanistan%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc


-- GLOBAL NUMBERS

Select Date,SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage 
From PortfolioProject..Covid_Deaths
--Where location like '%Afghanistan%'
where continent is not null
Group by date
Order by 1,2


Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage 
From PortfolioProject..Covid_Deaths
--Where location like '%Afghanistan%'
where continent is not null
--Group by date
Order by 1,2


-- Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
	dea.date) as RollingPeopleVaccinated
From PortfolioProject..Covid_Deaths dea
Join PortfolioProject..Covid_Vaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
Order by 2,3


-- TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated 
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
	dea.date) as RollingPeopleVaccinated
From PortfolioProject..Covid_Deaths dea
Join PortfolioProject..Covid_Vaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
Order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
	dea.date) as RollingPeopleVaccinated
From PortfolioProject..Covid_Deaths dea
Join PortfolioProject..Covid_Vaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order by 2,3
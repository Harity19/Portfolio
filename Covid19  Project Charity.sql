Select *
From PortfolioProjectCharity..CovidDeaths
Order by 3,4


Select *
From PortfolioProjectCharity..CovidVaccinations
Order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProjectCharity..CovidDeaths
Order by 1,2

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProjectCharity..CovidDeaths
Where location like '%Nigeria%'
Order by 1,2

Select location, date, total_cases, population, (total_cases/population)*100 as contactPercentage
From PortfolioProjectCharity..CovidDeaths
Where location like '%Nigeria%'
Order by 1,2


Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProjectCharity..CovidDeaths
Group by Location, Population
Order by PercentPopulationInfected

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProjectCharity..CovidDeaths
Where continent is not null
Group by continent
Order by TotalDeathCount desc

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
From PortfolioProjectCharity..CovidDeaths
Where continent is not null
group By date
Order by 1,2

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
From PortfolioProjectCharity..CovidDeaths
Where continent is not null
--group By date
Order by 1,2


Select *
From PortfolioProjectCharity..CovidVaccinations

Select *
From PortfolioProjectCharity..CovidDeaths dea
Join PortfolioProjectCharity..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date= vac.date

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location)
From PortfolioProjectCharity..CovidDeaths dea
Join PortfolioProjectCharity..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date= vac.date
	where dea.continent is not null
	order by 1,2,3

	with PopvsVac (continent, location, date, population, new_vaccination, RollingPeopleVaccinated) 
	as
	(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated-- (RollingPeopleVaccinated/population)*100
From PortfolioProjectCharity..CovidDeaths dea
Join PortfolioProjectCharity..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date= vac.date
	where dea.continent is not null
	--order by 2,3
	)
	select*, (RollingPeopleVaccinated/population)*100
	from PopvsVac
	

DROP table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
continent nvarchar (255),
location nvarchar (255),
date  datetime,
population numeric,
new_vaccination numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated-- (RollingPeopleVaccinated/population)*100
From PortfolioProjectCharity..CovidDeaths dea
Join PortfolioProjectCharity..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date= vac.date
	where dea.continent is not null
	--order by 2,3
	select*, (RollingPeopleVaccinated/population)*100
	from #PercentPopulationVaccinated


CREATE VIEW PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated-- (RollingPeopleVaccinated/population)*100
From PortfolioProjectCharity..CovidDeaths dea
Join PortfolioProjectCharity..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date= vac.date
where dea.continent is not null
---order by 2,3

Select *
from PercentPopulationVaccinated

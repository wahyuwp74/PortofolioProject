Select *
From dbo.CovidDeaths
where continent is not null
Order by 3,4

--Select *
--From dbo.CovidVaccinations
--Order by 3,4

Select location, date, total_cases, population, (total_cases/population)*100 AS PercentageCases
From dbo.CovidDeaths
where location like 'indo%' and continent is not null
Order by 1,2

Select location, max(total_cases) as HighestInfectiontCount, population, MAX((total_cases/population))*100 AS PercentagePopulationInfected
From dbo.CovidDeaths
--where location like 'indo%'
where continent is not null
group by population, location
Order by PercentagePopulationInfected desc


Select location, MAX(cast(total_deaths as int)) as TotalDeathsCount
From dbo.CovidDeaths
--where location like 'indo%'
where continent is not null
group by location
Order by TotalDeathsCount desc


Select continent, MAX(cast(total_deaths as int)) as TotalDeathsCount
From dbo.CovidDeaths
--where location like 'indo%'
where continent is not null
group by continent
Order by TotalDeathsCount desc

Select date, sum(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS PercentageDeaths
From dbo.CovidDeaths
-- where location like 'indo%' 
Where continent is not null
Group by date
Order by 1,2



Select dea.continent, dea.location, dea.date, vac.new_vaccinations, SUM(convert(float,vac.new_vaccinations)) 
OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated --(RollingPeopleVaccinated/population)*100 AS PercentageVacc
From dbo.CovidDeaths dea
join dbo.CovidVaccinations vac
on dea.location = vac.location and dea.date=vac.date
where dea.continent is not null
order by 2,3



with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(float,vac.new_vaccinations)) 
OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From dbo.CovidDeaths dea
join dbo.CovidVaccinations vac
on dea.location = vac.location and dea.date=vac.date
where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/population)*100 AS PercentageVacc
From PopvsVac



DROP Table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(float,vac.new_vaccinations)) 
OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From dbo.CovidDeaths dea
join dbo.CovidVaccinations vac
on dea.location = vac.location and dea.date=vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/population)*100 AS PercentageVacc
From #PercentPopulationVaccinated


Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, vac.new_vaccinations, dea.population, SUM(convert(float,vac.new_vaccinations)) 
OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated --(RollingPeopleVaccinated/population)*100 AS PercentageVacc
From dbo.CovidDeaths dea
join dbo.CovidVaccinations vac
on dea.location = vac.location and dea.date=vac.date
where dea.continent is not null
--order by 2,3

Select *
from PercentPopulationVaccinated


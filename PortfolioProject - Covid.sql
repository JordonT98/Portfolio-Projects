Select*
From PortFolioProject..CovidDeaths
Order by 3,4

select*
from PortFolioProject..CovidVaccinations
order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From PortFolioProject..CovidDeaths
Order by 1,2

-- "Analyzing the Relationship Between Total Cases and Total Deaths"
-- "Depicts the probability of fatality upon contracting COVID-19 in Jamaica"

Select Location, date, total_cases, total_deaths,(Total_deaths/Total_cases)*100 as DeathPercentage
From PortFolioProject..CovidDeaths
Where location like '%Jamaica%'
Order by 1,2

-- "Examining Total Cases Relative to Population Size"
-- "Indicates the Percentage of Population Affected by COVID-19 in Jamaica"

Select Location, date,Population, total_cases,(Total_cases/population)*100 as PrecentPopulationInfected
From PortFolioProject..CovidDeaths
Where location like '%Jamaica%'
Order by 1,2

-- "Examining Countries with the Highest COVID-19 Infection Rates Relative to Population"

Select Location, Population, MAX(total_cases) as HighestInfectionCount, Max ((Total_cases/population))*100 as PrecentPopulationInfected
From PortFolioProject..CovidDeaths
Group by Location, Population 
Order by PrecentPopulationInfected desc

-- "Highlighting Countries with the Highest Death Count per Capita" 

Select Location, Max(cast(Total_deaths as int)) as TotalDeathCount
From PortFolioProject..CovidDeaths
where continent is not null
Group by Location
Order by TotalDeathCount desc

-- "Global Trends in New Cases and New Deaths Over Time"

Select Date, sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Death, Sum(cast
(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortFolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2

-- "Global Trends in New Cases and New Deaths Total"

Select sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Death, Sum(cast
(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortFolioProject..CovidDeaths
where continent is not null
order by 1,2


--"Examining the Relationship Between Total Population and Vaccination Rates"

Select deaths.continent, deaths.location, deaths.date, deaths.population, vaccinations.new_vaccinations
, Sum(cast(vaccinations.new_vaccinations as int)) over (Partition by deaths.location order by deaths.location, deaths.date) as Immunizing_More_Individuals
from PortFolioProject..CovidDeaths as deaths
join PortFolioProject..CovidVaccinations as vaccinations
on deaths.location = vaccinations.location
and deaths.date = vaccinations.date
where deaths.continent is not null
order by 2,3


-- "CTE"

With PopulationvsVaccination (Continent, location, Date, Population, New_vaccinations, Immunizing_More_Individuals)
as
(
Select deaths.continent, deaths.location, deaths.date, deaths.population, vaccinations.new_vaccinations
, Sum(cast(vaccinations.new_vaccinations as int)) over (Partition by deaths.location order by deaths.location, deaths.date) as Immunizing_More_Individuals
from PortFolioProject..CovidDeaths as deaths
join PortFolioProject..CovidVaccinations as vaccinations
on deaths.location = vaccinations.location
and deaths.date = vaccinations.date
where deaths.continent is not null
--order by 2,3 
)

Select*, (Immunizing_More_Individuals/Population)*100 as Percentage_Population_Vaccinated_By_Date
From PopulationvsVaccination


-- "Temp Table"

Create Table #PercentagePopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
ImmunizingMoreIndividuals numeric
)

Insert into #PercentagePopulationVaccinated
Select deaths.continent, deaths.location, deaths.date, deaths.population, vaccinations.new_vaccinations
, Sum(cast(vaccinations.new_vaccinations as int)) over (Partition by deaths.location order by deaths.location, deaths.date) as ImmunizingMoreIndividuals
from PortFolioProject..CovidDeaths as deaths
join PortFolioProject..CovidVaccinations as vaccinations
on deaths.location = vaccinations.location
and deaths.date = vaccinations.date
where deaths.continent is not null
order by 2,3


Select*, (ImmunizingMoreIndividuals/Population)*100 as ImunizingvsPopulation
From #PercentagePopulationVaccinated


-- "Generating a view for storing data to be used in subsequent visualizations"


Create View PercentagePopulationVaccinated as 
Select deaths.continent, deaths.location, deaths.date, deaths.population, vaccinations.new_vaccinations
, Sum(cast(vaccinations.new_vaccinations as int)) over (Partition by deaths.location order by deaths.location, deaths.date) as ImmunizingMoreIndividuals
from PortFolioProject..CovidDeaths as deaths
join PortFolioProject..CovidVaccinations as vaccinations
on deaths.location = vaccinations.location
and deaths.date = vaccinations.date
where deaths.continent is not null



select*
from PercentagePopulationVaccinated














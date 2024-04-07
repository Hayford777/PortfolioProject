select *
from CovidDeaths


select  *
from Covid19Vaccination


select *
from CovidDeaths
order by 3,4

select *
from Covid19Vaccination
order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths
order by 1,2

--looking at the total cases vs total deaths
--likehood of dying if you have Covid in your country

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPerCases
from CovidDeaths
where location like '%state%'
order by 1,2 

 --looking at total cases Vs population
 select location,date,total_cases,population,(total_cases/population)*100
from CovidDeaths
where location like '%ghana%'
order by 1,2

--contries with the highest infection rate 


 select location,max(total_cases) as TotalCasesPerCountry,population,max((total_cases/population))*100 as RateOfEffect
from CovidDeaths
--where location like '%ghana%'
group by location,population
order by RateOfEffect desc

--showing the countries with highest  death count population

select location,max(CAST(total_deaths AS INT)) AS overallDeath ,population
from CovidDeaths
WHERE continent is not null
group by location,population
order by overallDeath DESC




--Breaking into continents 
select location,max(CAST(total_deaths AS INT)) AS overallDeath ,population
from CovidDeaths
WHERE continent is null
group by location,population
order by overallDeath DESC

--showing the continent with the highest death count 

select continent,max(total_deaths) as overallDeath
from CovidDeaths
where continent is not null
group by continent
order by overallDeath desc

--lookking at global numbers 

select date,sum(new_cases) AS EachDayCases ,sum(cast(new_deaths as int)) as EachDayDeath
from CovidDeaths
WHERE continent is not null
group by date
order by 1,2

select*
from CovidDeaths
join Covid19Vaccination
on CovidDeaths.location=Covid19Vaccination.location
order by 3,4


select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.location) as rollingPeopleVaccinations

from CovidDeaths as dea
join Covid19Vaccination as vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3


--using cte
with PopvsVac(Continent,location,Date,Population,	NewVaccinati,rollingPeopleVaccinated)
as
(
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.location) as rollingPeopleVaccinations

from CovidDeaths as dea
join Covid19Vaccination as vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
)
select*,(rollingPeopleVaccinated/Population)*100
from PopvsVac

 --temp table 
 drop table if exists #PercentPeopleVaccinated
create table #PercentPeopleVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccination numeric,
rollingPeopleVaccinated numeric
)


insert into #PercentPeopleVaccinated
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.location) as rollingPeopleVaccinated

from CovidDeaths as dea
join Covid19Vaccination as vac
on dea.location=vac.location
and dea.date=vac.date
select *,(rollingPeopleVaccinated/population)*100
from #PercentPeopleVaccinated


--creating views to store data for later visualization


create view PercentPeopleVaccinated as
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.location) as rollingPeopleVaccinated

from CovidDeaths as dea
join Covid19Vaccination as vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null


select *
from PercentPeopleVaccinated


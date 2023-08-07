SELECT TOP (1000) [iso_code]
      ,[continent]
      ,[location]
      ,[date]
      ,[total_tests]
      ,[new_tests]
      ,[total_tests_per_thousand]
      ,[new_tests_per_thousand]
      ,[new_tests_smoothed]
      ,[new_tests_smoothed_per_thousand]
      ,[positive_rate]
      ,[tests_per_case]
      ,[tests_units]
      ,[total_vaccinations]
      ,[people_vaccinated]
      ,[people_fully_vaccinated]
      ,[total_boosters]
      ,[new_vaccinations]
      ,[new_vaccinations_smoothed]
      ,[total_vaccinations_per_hundred]
      ,[people_vaccinated_per_hundred]
      ,[people_fully_vaccinated_per_hundred]
      ,[total_boosters_per_hundred]
      ,[new_vaccinations_smoothed_per_million]
      ,[new_people_vaccinated_smoothed]
      ,[new_people_vaccinated_smoothed_per_hundred]
      ,[stringency_index]
      ,[population_density]
      ,[median_age]
      ,[aged_65_older]
      ,[aged_70_older]
      ,[gdp_per_capita]
      ,[extreme_poverty]
      ,[cardiovasc_death_rate]
      ,[diabetes_prevalence]
      ,[female_smokers]
      ,[male_smokers]
      ,[handwashing_facilities]
      ,[hospital_beds_per_thousand]
      ,[life_expectancy]
      ,[human_development_index]
      ,[excess_mortality_cumulative_absolute]
      ,[excess_mortality_cumulative]
      ,[excess_mortality]
      ,[excess_mortality_cumulative_per_million]
  FROM [AdamsProject1].[dbo].[CovidVaccinations]

  
    select count(*)
  from CovidDeath

  -- to check for the two tables

   select*
  from CovidVaccinations

   select* 
  from CovidDeath
  
    
   select* 
  from CovidDeath 
  where continent is not Null
  order by 3,4

    select* 
  from CovidDeath
  order by 3,4

  --select Data we are going to be using 

  select location, date,total_cases,new_cases,total_deaths,population
  from CovidDeath
  order by 1,2


  -- looking at Total cases vs Total Death 

  select location, date,total_cases,total_deaths,(total_deaths / total_cases)*100 as DeathPercentage
  from CovidDeath
    where location like'%nigeria%'
  order by 1,2

  
  
 -- Looking at Total cases Vs Population

  
  select location, date,total_cases,population,( total_cases / population)*100 as DeathPercentage
  from CovidDeath
    where location like'%nigeria%'
  order by 1,2

--Looking at Countries highest infection rate compare to the population

  select location, population, Max (total_cases) as highestInfectionCount, Max ( total_cases / population)*100 as PercentPupolationAffected
  from CovidDeath
  --  where location like'%nigeria%'
   where continent is not Null
  group by location,population
  order by 1,2

  
  select location, population, Max (total_cases) as highestInfectionCount, Max ( total_cases / population)*100 as PercentPupolationAffected
  from CovidDeath
  group by location,population
  order by PercentPupolationAffected desc

  --- countries with the highest death count per population

  
    select location, population, Max (total_deaths) as totaldeathCount
  from CovidDeath
  group by location,population
  order by totaldeathCount desc 


    select location, population, Max (total_deaths) as totaldeathCount, Max ( total_deaths / population)*100 as totaldeathCountpercentage
  from CovidDeath
   where continent is not Null
  group by location,population
  order by totaldeathCountpercentage desc


  ---Let break things down by continent


    select continent, Max (cast(total_deaths as  int)) as totaldeathCount
  from CovidDeath
  where continent is not Null
  group by continent
  order by totaldeathCount desc 

   select location, Max (cast(total_deaths as  int)) as totaldeathCount
  from CovidDeath
  where continent is not Null
  group by location
  order by totaldeathCount desc 

     select location, Max (cast(total_deaths as  int)) as totaldeathCount
  from CovidDeath
  where continent is  Null
  group by location
  order by totaldeathCount desc 

  -- Showing the continent with highest death count per population

  
    select continent, Max (cast(total_deaths as  int)) as totaldeathCount
  from CovidDeath
  where continent is not Null
  group by continent
  order by totaldeathCount desc 

-- Global Numbers



      select date, total_cases total_deaths, (cast(total_deaths as  int)) as totaldeathCount
  from CovidDeath
  where continent is  Null
  order by 1,2

      select date, total_cases total_deaths, (cast(total_deaths as  int)) as totaldeathCount
  from CovidDeath
  where continent is  Null
  order by totaldeathCount desc 

      select date,Sum (new_cases) as NewCasesSum, Sum (new_deaths) as NewDeathSum
  from CovidDeath
  where continent is  Null
  group by date
  order by 1,2


  -- To know the global percentage

        select sum (new_cases) as NewCase, Sum (new_deaths) As DeathCases,
		(Sum (new_cases) / Sum (new_deaths))*100 As DeathPercentage 
  from CovidDeath
  where continent is not null
  --Group by date
  order by 1,2 
 
 -- Let's work on covidvaccinations 

select*
from CovidVaccinations

 select*
 from CovidDeath a
Join CovidVaccinations b
on a.location=b.location
and a.date=b.date
 

--- Looking at Total Population Vs Vaccinations

 select*
 from CovidDeath a
Join CovidVaccinations b
on a.location=b.location
and a.date=b.date
 

 select a.continent,a.location, a.date, b.new_vaccinations
 from CovidDeath a
Join CovidVaccinations b
on a.location=b.location
and a.date=b.date
 where a.continent is not null
  order by 1,2 ,3
 

 select a.continent, a.location, a.date, a.population, b.new_vaccinations,
 Sum (cast(b.new_vaccinations as tinyint)) over (partition by a.location order by a.location,a.date) 
 as RollingPeopleVaccinated
 from CovidDeath a
Join CovidVaccinations b
on a.location=b.location
and a.date=b.date
 where a.continent is not null
  order by 2,3

 --- CTE
 
With PopVsVac (continent, Location, Date,population,New_vaccinations, RollingpeopleVaccinated)
 as 
 (
  select a.continent, a.location, a.date, a.population, b.new_vaccinations,
 Sum( cast(b.new_vaccinations as int)) over  (partition by a.location order by a.location,a.date) 
 as RollingPeopleVaccinated
 from CovidDeath a
Join CovidVaccinations b
on a.location=b.location
and a.date=b.date
 where a.continent is not null
  --order by 2,3
  )
  select* 
  from PopVsVac

  

  --Temp Table

   drop table if exists #PercentPopulatonVaccination
  
  create table #PercentPopulatonVaccination
  (
  continent nvarchar (255),
  location nvarchar ( 255),
  date datetime, 
  pupolation numeric,
 new_vaccinations numeric ,
 RollingPeopleVaccinated numeric
 )
  
  insert into #PercentPopulatonVaccination
  select a.continent, a.location, a.date, a.population, b.new_vaccinations,
 Sum(cast(b.new_vaccinations as int))over (partition by a.location order by a.location,a.date) 
 as RollingPeopleVaccinated 
 from CovidDeath a
Join CovidVaccinations b 
on a.location=b.location
and a.date=b.date
 where a.continent is not null
 -- order by 2,3


   select*
  from #PercentPopulatonVaccinated



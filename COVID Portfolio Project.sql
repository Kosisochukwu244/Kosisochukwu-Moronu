
-- My SQL PortfolioProject:

select *
from CovidDeaths

order by 1,2

--- select data to use :

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
where total_cases is not null and total_deaths is not null
order by 1, 2

--- looking at the total_cases vs the total_deaths:

select location, date, total_cases, new_cases, total_deaths, population, 
(convert (float, total_deaths)/convert (float, total_cases)) * 100
as 'total_deaths percentage'
from CovidDeaths
where 'total_cases' is not null 
order by 6,7 


--- looking at the total_cases vs the total_deaths where location is curacao:

select location, date, total_cases, new_cases, (total_deaths) , population, 
(convert (float, total_deaths)/convert (float, total_cases)) * 100
as 'total_deaths percentage'
from CovidDeaths
where location = 'Curacao'
order by 6,7  

-- Let's take a look at the total cases vs the population:

select location, population,  date, total_cases,  total_deaths, 
(convert (float, total_cases)/convert (float,population)) * 100
as '  percentage of the population with covid '
from CovidDeaths
where location = 'Curacao' 
order by 1,2,3,4,5,6 DESC

/* Let's take  a look at the Countries with the highest infection rate as compared to 
the Population: */

Select location, population,  max(total_cases) as 'Highest Infection Count (HIC)', 
 max(convert (float, total_cases)/convert (float,population)) *100 
as '  percentage of the population with covid '
from CovidDeaths
group by   location ,population
order by [  percentage of the population with covid ] desc

-- To show the Countries with the HIgest Death Coount:

Select location, max(total_deaths) as 'Total Death Count'
from CovidDeaths
group by    location
order by [Total Death Count] desc

-- Breaking it further to look at continents:

Select  continent, max(total_deaths) as 'Total Death Count'
from CovidDeaths
where continent is not null
group by   continent
order by [Total Death Count] desc

-- Global numbers:

Select date,  sum(new_cases) , sum(new_deaths),( sum(new_deaths)/sum(new_cases)) * 100
-- continent, max(total_deaths) as 'Total Death Count'
from CovidDeaths
where continent is not null and new_cases <> 0
group by   date 
order by 1,2 desc


Select   sum(new_cases) as 'total cases' , sum(new_deaths) as 'total deaths',( sum(new_deaths)/sum(new_cases)) * 100
 as 'Death Percentage'-- continent, max(total_deaths) as 'Total Death Count'
from CovidDeaths
where continent is not null and new_cases <> 0
---group by   date 
order by 1,2 desc


--- Joining two tables together:
-- first select the second table 

Select *
from CovidDeaths Dth
join CovidVaccinations Vac
     on Dth.location = Vac.location
	 and 
	 Dth.date = Vac.date

--- Looking at the total number of humans in the world that have been vaccinated :

Select Dth.location, Dth.population,Dth.date, Vac.new_vaccinations, Dth.continent,
sum(convert(float, Vac.new_vaccinations))  over (partition by Dth.location order by Dth.location, Dth.date)
as Rolling_people_vaccinated
from CovidDeaths Dth
join CovidVaccinations Vac
     on Dth.location = Vac.location
	 and 
	 Dth.date = Vac.date 
where Dth.continent is not null
order by 1,2,3

--USE CTE

With PopvsVac( location, population, new_vaccinations, continent, date, Rolling_people_vaccinated)
as
( Select Dth.location, Dth.population,Dth.date, Vac.new_vaccinations, Dth.continent,
sum(convert(float, Vac.new_vaccinations))  over (partition by Dth.location order by Dth.location, Dth.date)
as Rolling_people_vaccinated
from CovidDeaths Dth
join CovidVaccinations Vac
     on Dth.location = Vac.location
	 and 
	 Dth.date = Vac.date 
where Dth.continent is not null
--order by 1,2
)
select *, (Rolling_people_vaccinated/population) * 100
from PopvsVac

--USE TEMP TABLE :
Drop Table if exists  #Percent_Population_Vaccinated
Create table #Percent_Population_Vaccinated
(location nvarchar(255),
population numeric,
new_vaccinations numeric,
continent nvarchar(255),
 date datetime ,
Rolling_people_vaccinated numeric
)

Insert into #Percent_Population_Vaccinated
 Select Dth.location, Dth.population,Dth.date, Vac.new_vaccinations, Dth.continent,
sum(convert(float, Vac.new_vaccinations))  over (partition by Dth.location order by Dth.location, Dth.date)
as Rolling_people_vaccinated
from CovidDeaths Dth
join CovidVaccinations Vac
     on Dth.location = Vac.location
	 and 
	 Dth.date = Vac.date 
where Dth.continent is not null
--order by 1,2

select *
from #Percent_Population_Vaccinated

--Creating View for visualisation

Create view Percent_Population_Vaccinated as 
Select Dth.location, Dth.population,Dth.date, Vac.new_vaccinations, Dth.continent,
sum(convert(float, Vac.new_vaccinations))  over (partition by Dth.location order by Dth.location, Dth.date)
as Rolling_people_vaccinated
from CovidDeaths Dth
join CovidVaccinations Vac
     on Dth.location = Vac.location
	 and 
	 Dth.date = Vac.date 
where Dth.continent is not null
--order by 1,2
select *
from Percent_Population_Vaccinated













  





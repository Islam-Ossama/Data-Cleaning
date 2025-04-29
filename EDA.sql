---1.0basic aggregation functions
select 
    max (total_laid_off),
    max (percent_laid_off)
from layoff_cleaned

----2.0 companies which had total laid off
Select *
from layoff_cleaned
where percent_laid_off = 1
and total_laid_off is not null
order by total_laid_off desc

----3.0 companies with the highest layoff
select 
    company,
    sum(total_laid_off)
from layoff_cleaned
where total_laid_off is not null
group by company
order by 2 desc

----4.0 date range of layoff
Select
    min (date),
    max (date)
from layoff_cleaned

----5.0 industry with the highest layoff
select 
    industry,
    sum(total_laid_off)
from layoff_cleaned
where total_laid_off is not null
group by industry
order by 2 desc

----6.0 country with the highest layoff
select 
    country,
    sum(total_laid_off)
from layoff_cleaned
where total_laid_off is not null
group by country
order by 2 desc

----7.0 dates with the highest layoff
select 
    EXTRACT(YEAR FROM date) AS order_year,
    sum(total_laid_off)
from layoff_cleaned
where total_laid_off is not null
group by order_year
order by 1 desc

----8.0 dates with the highest layoff
select 
    stage,
    sum(total_laid_off)
from layoff_cleaned
where total_laid_off is not null
group by stage
order by 2 desc

----9.0 Rolling total 
----9.1 how many people lost their jobs per month
select 
    EXTRACT(month FROM date) AS month_num,
    sum (total_laid_off)
from layoff_cleaned
group by month_num
order by 1 asc

----9.2 rolling total over the whole time series
with Rolling_total as (
select 
    TO_CHAR(DATE, 'YYYY-MM') AS year_month,
    sum (total_laid_off) as total_off
from layoff_cleaned
group by year_month
order by 1 
)
Select
    year_month,
    total_off,
    sum(total_off)over (order by year_month) total_rolling
from Rolling_total

----10.0 comapanies lay off per year
Select
    company,
    EXTRACT (Year from date),
    sum (total_laid_off)
from layoff_cleaned
where total_laid_off is not null
group by company, EXTRACT (Year from date)
order by 3 desc

----10.1 ranking of comapny based on tota layoff per year
with comapny_year (company,years, total_laid_off) as (
    Select
    company,
    EXTRACT (Year from date),
    sum (total_laid_off)
from layoff_cleaned
where total_laid_off is not null
group by company, EXTRACT (Year from date)
), company_year_rank as (
select *,
dense_rank () over (partition by years order by total_laid_off desc) as ranking
from comapny_year
--order by ranking asc, years asc;; this line is a comma as we don't need the order and the rank togther.
)
select *
from company_year_rank
where ranking <= 5 
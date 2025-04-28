Create table layoff (
    company VARCHAR (50),
    location VARCHAR (50),
    industry VARCHAR (50),
    total_laid_off VARCHAR (50),
    percent_laid_off VARCHAR (50),
    date VARCHAR (25),
    stage VARCHAR(50),
    country VARCHAR (50),
    fund_raised_millions VARCHAR (50)
)

copy layoff (company, location, industry, total_laid_off, percent_laid_off, date, stage, country, fund_raised_millions)
from 'C:\Islam\Data analysis\SQL Projects\Cleaning data\layoffs data cleaning.csv'
DELIMITER ',' CSV HEADER

---------------------------------------------------------------------------------------------------------
--data cleaning--
-- 1- Remove duplicates
with duplicates as (
select *,
row_number () over (partition by company, location,industry, 
total_laid_off, percent_laid_off, date, 
stage, country,fund_raised_millions) as row_num
from layoff
)
--- 1.1- create new table to manupiulate more easily
create table layoff_cleaned (
        company VARCHAR (50),
    location VARCHAR (50),
    industry VARCHAR (50),
    total_laid_off VARCHAR (50),
    percent_laid_off VARCHAR (50),
    date VARCHAR (25),
    stage VARCHAR(50),
    country VARCHAR (50),
    fund_raised_millions VARCHAR (50),
    row_num int
);

----1.1.1 adding data into the new table + the row_number
insert into layoff_cleaned
select *,
row_number () over (partition by company, location,industry, 
total_laid_off, percent_laid_off, date, 
stage, country,fund_raised_millions) as row_num
from layoff;

----1.1.2 delete duplicates from this new table 
delete 
from layoff_cleaned
where row_num > 1;

----1.1.3 verfiying date
select *
from layoff_cleaned
where row_num > 1;

-- 2- standardize date format
----2.1 checking the data for the companies
select
    company,
    trim (company)
from layoff_cleaned

----2.2 updating the data
update layoff_cleaned
set company = trim (company)

----2.3 checking the data for the countries
select distinct (country)
from layoff_cleaned
order by 1

----2.4 standerdizing the countries names
update layoff_cleaned
set country = 'United States'
where country like 'United States%'

----2.5 checking the data for the industries
SELECT distinct (industry)
from layoff_cleaned
order by 1

----2.6 standerdizing the industry names
update layoff_cleaned
set industry = 'Crypto'
where industry like 'Crypto%'

select *
from layoff_cleaned
where company = 'Airbnb'

----2.7 checking the data for the date
select date
from layoff_cleaned
where date = 'NULL'

----2.7.1 converting 'NULL' from string to null values
update layoff_cleaned
set date = NULL
where date = 'NULL'

---2.8 standerdizing the date
----2.8.1 converting date formating
update layoff_cleaned
    set date = TO_DATE(date, 'MM/DD/YYYY')
where date is not Null;

----2.8.2 changing the date column type
alter table layoff_cleaned
ALTER COLUMN "date" SET DATA TYPE date USING ("date"::date);

---3.0 Null values

----3.1 null in industry column
select distinct (industry)
from layoff_cleaned

select *
from layoff_cleaned
where industry = 'NULL'
or industry is null 

-----3.1.1 checking each company alone
select *
from layoff_cleaned
where company = 'Carvana'; --- there are other entries with the industry category

select *
from layoff_cleaned
where company = 'Airbnb' --- there are other entries with the industry category

select *
from layoff_cleaned
where company like 'Bally%'  --- there are NO other entries with the industry category

select *
from layoff_cleaned
where company like 'Juul%' --- there are other entries with the industry category

-----3.1.2 updating the industry category for those having other entries

-----3.1.2.1 joining the table on itself to find the industries for thoese having other entries
SELECT t1.industry, t2.industry
from layoff_cleaned t1
join layoff_cleaned t2 on t1.company = t2.company
where t1.industry is null 
and t2.industry is not null

-----3.1.2.2 updating the missing values (Nulls)

UPDATE layoff_cleaned t1
SET industry = t2.industry
FROM layoff_cleaned t2
WHERE t1.company = t2.company
  AND t1.industry IS NULL
  AND t2.industry IS NOT NULL; ----there is still a null value but this has no other entries of the same company name

----3.2 null in other columns (total_laid_off & percentage_laid_off)
----3.2.1 verifying Null values
select *
from layoff_cleaned
where total_laid_off = 'NULL'
and percent_laid_off = 'NULL'
----3.2.2 removing Null values 
delete
from layoff_cleaned
where total_laid_off = 'NULL'
and percent_laid_off = 'NULL'

----3.2.3 setting 'Null' from string into null values for total laid off
update layoff_cleaned
set total_laid_off = Null
where total_laid_off = 'NULL'

----3.2.3.1 changing the data type of the column
alter table layoff_cleaned
ALTER COLUMN total_laid_off type int using total_laid_off::int 

----3.2.4 setting 'Null' from string into null values for percent laid off
update layoff_cleaned
set percent_laid_off = Null
where percent_laid_off = 'NULL'
----3.2.4.1 changing the data type of the column
alter table layoff_cleaned
alter column percent_laid_off type decimal using percent_laid_off::decimal

----3.3 changes of the fund raised millions column
----3.3.1 change string 'NULL' into null values
update layoff_cleaned
set fund_raised_millions = Null
where fund_raised_millions = 'NULL'

----3.3.2 chagning the column type 
alter table layoff_cleaned
alter column fund_raised_millions type decimal using fund_raised_millions::decimal

----4.0 
alter table layoff_cleaned
drop column row_num

----5.0 final table
select *
from layoff_cleaned
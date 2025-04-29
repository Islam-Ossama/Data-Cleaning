# Layoffs Data Cleaning and Analysis Project

## Project Overview

This project focuses on cleaning and analyzing layoffs data using SQL to ensure data quality and derive meaningful insights. The process involves cleaning the raw dataset through multiple steps like removing duplicates, standardizing formats, handling null values, and then performing exploratory data analysis (EDA) to uncover trends in layoffs across companies, industries, countries, and time periods.

## Table of Contents

- Project Overview
- Dataset
- Prerequisites
- Setup
- Data Cleaning Workflow
- Analysis Workflow
- Key Queries
- Results
- Contributing
- License

## Dataset

- **Source**: The dataset is sourced from the provided "layoffs data cleaning.csv" file.
- **Description**: The dataset contains records of layoffs across various companies, including columns like `company`, `location`, `industry`, `total_laid_off`, `percent_laid_off`, `date`, `stage`, `country`, and `fund_raised_millions`, representing layoff events and their details.
- **Schema**:
  - `company`: Name of the company
  - `location`: Company location
  - `industry`: Industry sector of the company
  - `total_laid_off`: Number of employees laid off
  - `percent_laid_off`: Percentage of employees laid off
  - `date`: Date of the layoff event (MM/DD/YYYY format)
  - `stage`: Company stage (e.g., Post-IPO, Series A)
  - `country`: Country of the company
  - `fund_raised_millions`: Funds raised by the company in millions

## Prerequisites

- SQL-compatible database (e.g., PostgreSQL)
- SQL client (e.g., DBeaver, pgAdmin, or command-line interface)

## Setup

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/Islam-Ossama/Layoff-analysis.git
   ```

2. **Set Up the Database**:

   - Import the dataset into your SQL database using the provided `layoffs data cleaning.csv`.
   - Example for PostgreSQL:

     ```bash
     psql -U username -d layoffs_db -c "\copy layoff FROM 'C:\Islam\Data analysis\SQL Projects\Cleaning data\layoffs data cleaning.csv' DELIMITER ',' CSV HEADER;"
     ```

## Data Cleaning Workflow

1. **Remove Duplicates**:
   - Created a new table `layoff_cleaned` with a `row_num` column to identify duplicates using a `ROW_NUMBER()` function.
   - Deleted rows where `row_num > 1` to eliminate duplicates.
   - Verified the removal of duplicates by checking for rows with `row_num > 1`.

2. **Standardize Data**:
   - Trimmed whitespace from the `company` column.
   - Standardized `country` names (e.g., converted "United States%" to "United States").
   - Standardized `industry` names (e.g., converted "Crypto%" to "Crypto").
   - Converted the `date` column format using `TO_DATE()` to handle `MM/DD/YYYY` and changed its data type to `DATE`.

3. **Handle Null Values**:
   - Converted string `'NULL'` to actual `NULL` values in `date`, `total_laid_off`, `percent_laid_off`, and `fund_raised_millions` columns.
   - Populated missing `industry` values by joining the table on itself to find matching industries for companies with multiple entries.
   - Deleted rows where both `total_laid_off` and `percent_laid_off` were `NULL`.
   - Changed data types of `total_laid_off` to `INT`, and `percent_laid_off` and `fund_raised_millions` to `DECIMAL`.

4. **Final Adjustments**:
   - Dropped the `row_num` column from the cleaned table after deduplication.

## Analysis Workflow

1. **Exploratory Data Analysis (EDA)**:
   - Performed basic aggregations to find maximum layoffs and percentages.
   - Analyzed companies with 100% layoffs, highest layoffs by company, industry, country, and stage.
   - Examined layoff trends over time, including yearly and monthly breakdowns, and calculated rolling totals.

2. **Query Development**:
   - Wrote SQL queries to calculate key metrics like total layoffs by company, industry, country, and stage, as well as time-based trends.
   - Ranked companies by layoffs per year using `DENSE_RANK()` to identify top contributors.

## Key Queries

Below are examples of SQL queries used in the analysis:

- **Query 1**: Companies with the highest layoffs

  ```sql
  SELECT 
      company,
      SUM(total_laid_off)
  FROM layoff_cleaned
  WHERE total_laid_off IS NOT NULL
  GROUP BY company
  ORDER BY 2 DESC;
  ```

- **Query 2**: Industry with the highest layoffs

  ```sql
  SELECT 
      industry,
      SUM(total_laid_off)
  FROM layoff_cleaned
  WHERE total_laid_off IS NOT NULL
  GROUP BY industry
  ORDER BY 2 DESC;
  ```

- **Query 3**: Rolling total of layoffs over time

  ```sql
  WITH Rolling_total AS (
      SELECT 
          TO_CHAR(DATE, 'YYYY-MM') AS year_month,
          SUM(total_laid_off) AS total_off
      FROM layoff_cleaned
      GROUP BY year_month
      ORDER BY 1 
  )
  SELECT
      year_month,
      total_off,
      SUM(total_off) OVER (ORDER BY year_month) total_rolling
  FROM Rolling_total;
  ```

## Results

- **Data Quality**: Successfully removed duplicates, standardized formats, and handled null values, resulting in a clean dataset for analysis.
- **Layoff Trends**:
  - Identified companies with the highest layoffs and those with 100% layoffs.
  - Found industries and countries with the most significant layoff impacts.
  - Analyzed layoff trends over time, with yearly and monthly breakdowns showing key periods of high layoff activity.
  - Ranked companies by layoffs per year, highlighting top contributors annually.
- The SQL scripts provide a foundation for further analysis and visualization in tools like Power BI or Tableau.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your changes. For major updates, open an issue to discuss first.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

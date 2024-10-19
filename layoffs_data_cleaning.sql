-- SQL Project - Data Cleaning

-- https://www.kaggle.com/datasets/swaptr/layoffs-2022 

-- Step 1: Display all records from the raw layoffs table
-- This query fetches all the data from the original layoffs table to review its contents before cleaning.
SELECT *
FROM layoffs;

-- DATA CLEANING STEPS: 
-- 1. REMOVE DUPLICATES
-- 2. STANDARDIZE THE DATA
-- 3. HANDLE NULL VALUES OR BLANK VALUES
-- 4. REMOVE ANY COLUMNS NOT RELEVANT 

-- Step 2: Create a staging table to copy all data from the raw table
-- A new table 'layoffs_staging' is created to hold the raw data temporarily for cleaning purposes.
CREATE TABLE layoffs_staging
LIKE layoffs; 

-- Step 3: Insert all data into the staging table
-- This query copies all data from the original layoffs table into the staging table for processing.
INSERT layoffs_staging
SELECT * 
FROM layoffs;

-- Step 4: Check the staging table
-- Run this query to verify that all data has been successfully copied into the staging table.
SELECT * 
FROM layoffs_staging;

-- Step 5: Remove duplicates
-- Create a Common Table Expression (CTE) to find duplicates based on key columns.
WITH duplicate_cte AS (
    SELECT *,
    ROW_NUMBER() OVER(
        PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
    ) AS row_num
    FROM layoffs_staging
)

-- Step 6: Check for duplicates
-- This query retrieves all entries from the CTE where the row number indicates a duplicate.
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Step 7: Check specific company for duplicates
-- Here, we check for duplicate entries for the company 'Oda' to understand its records.
SELECT *
FROM layoffs_staging 
WHERE company='Oda';

-- Check duplicates for the company 'Casper' for further investigation.
SELECT *
FROM layoffs_staging 
WHERE company = 'Casper';

-- Step 8: Create a new table for removing duplicates
-- A new table 'layoffs_staging2' is created, including an extra column to identify duplicates by their row number.
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Step 9: Insert data into the new table with row number
-- Copy data from the staging table into the new table while assigning a row number to identify duplicates.
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
    PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging; 

-- Step 10: Check the new table
-- This query checks the contents of the new table to ensure data was correctly inserted.
SELECT *
FROM layoffs_staging2;

-- Step 11: Filter rows where row_num > 1 to remove duplicates
-- Here, we identify which rows are duplicates based on the row number generated in the previous step.
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- Step 12: Delete duplicates from the new table
-- This query removes duplicate rows from the new table based on the row number.
DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

-- Step 13: Check the table after deletion
-- Verify the contents of the new table to confirm that duplicates have been removed.
SELECT *
FROM layoffs_staging2;

-- Step 14: Standardizing data: check for spaces in company names
-- This query helps identify and visualize any unwanted spaces in the company names for standardization.
SELECT *
FROM layoffs_staging2; 

-- Step 15: Trim spaces from the company names
-- This query updates the company names in the new table to remove leading and trailing spaces.
UPDATE layoffs_staging2 
SET company = TRIM(company);

-- Step 16: Standardizing the industry column
-- Here, we check the unique values in the industry column to find inconsistencies.
SELECT DISTINCT industry 
FROM layoffs_staging2
ORDER BY 1;

-- Check for variations of 'Crypto' in the industry column to standardize.
SELECT *
FROM layoffs_staging2 
WHERE industry LIKE 'Crypto%'; 

-- Update inconsistent industry names to 'Crypto'
-- This query standardizes all variations of 'Crypto' to a single entry.
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Step 17: Check unique industry names
-- This confirms that the industry names have been standardized and no duplicates exist.
SELECT DISTINCT industry 
FROM layoffs_staging2;

-- Step 18: Review the location and country columns
-- This checks the unique entries in the location column for any irregularities.
SELECT DISTINCT location 
FROM layoffs_staging2;

-- Check the unique entries in the country column.
SELECT DISTINCT country 
FROM layoffs_staging2;

-- Step 19: Fix the trailing period in 'United States'
-- This query updates the country names by removing any trailing periods for consistency.
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country) 
WHERE country LIKE 'United States%'; 

-- Step 20: Convert date column from text to date type
-- This updates the date column, converting the text representation to a standard date format.
UPDATE layoffs_staging2 
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Step 21: Change the column type to DATE
-- Here, we modify the date column's data type to ensure it is recognized as a date type in the database.
ALTER TABLE layoffs_staging2 
MODIFY COLUMN `date` DATE;

-- Step 22: Check for NULLs and blanks
-- This identifies records where both total_laid_off and percentage_laid_off are NULL.
SELECT *
FROM layoffs_staging2 
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL; 

-- Check for any NULL or blank entries in the industry column.
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = ''; 

-- Step 23: Fill NULL values for Airbnb's industry
-- Here, we first convert empty strings in the industry column to NULL for uniformity.
UPDATE layoffs_staging2 
SET industry = NULL 
WHERE industry = '';

-- Populate the NULL industry values for Airbnb by joining the table on company and location.
UPDATE layoffs_staging2 AS t1  
JOIN layoffs_staging2 AS t2 
ON t1.company = t2.company 
SET t1.industry = t2.industry 
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

-- Step 24: Verify that NULLs are filled
-- This checks if the industry values for Airbnb have been successfully populated.
SELECT *
FROM layoffs_staging2 
WHERE company = 'Airbnb'; 

-- Confirm that there are no remaining NULL or blank industry values.
SELECT *
FROM layoffs_staging2 
WHERE industry IS NULL 
OR industry = ''; 

-- Step 25: Delete rows with NULL total_laid_off and percentage_laid_off
-- This query removes any records where both total_laid_off and percentage_laid_off are NULL, as they are irrelevant to the analysis.
DELETE 
FROM layoffs_staging2 
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;  

-- Step 26: Verify deletion
-- Confirm that no rows remain with NULL values for total_laid_off and percentage_laid_off after the deletion.
SELECT *
FROM layoffs_staging2 
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL; 

-- Step 27: Final check of the cleaned data
-- This retrieves the final state of the cleaned data in the staging table.
SELECT *
FROM layoffs_staging2;

-- Step 28: Drop the row_num column as it's no longer needed
-- This removes the row_num column from the final table since it has served its purpose.
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- Final step: Display the finalized cleaned data
-- This displays the cleaned data in the staging table after all processing steps have been completed.
SELECT *
FROM layoffs_staging2;

# Portfolio-Project-layoffs-data-cleaning-2024
A comprehensive data cleaning project focused on processing layoffs data from various companies. This project involves removing duplicates, standardizing entries, handling missing values, and preparing the dataset for analysis. The repository includes SQL queries for each cleaning step, along with detailed documentation.

Layoffs Data Cleaning (2024)
Description:
This repository contains a comprehensive SQL project focused on cleaning and preparing a dataset related to layoffs in various companies. The dataset is sourced from Kaggle and includes critical information about layoffs such as company names, industry, total laid off, percentage laid off, dates, stages, and countries.

The primary objective of this project is to ensure the dataset is clean, consistent, and ready for further analysis, enabling effective data-driven decisions.

Table of Contents
- Project Overview
- Data Cleaning Steps
- Challenges Faced
- Outcomes
- Usage
- Dataset: https://www.kaggle.com/datasets/swaptr/layoffs-2022

  
Project Overview

The project follows a systematic approach to data cleaning, encompassing several steps to remove duplicates, standardize data, and handle null or blank values. Each step is meticulously documented in the SQL code, making it easy to understand the processes involved.

Data Cleaning Steps
1. Initial Data Review: Display all records from the raw layoffs table.
2. Create Staging Table: Set up a staging table to hold raw data for cleaning.
3. Duplicate Removal: Identify and remove duplicate records using Common Table Expressions (CTEs).
4. Data Standardization: Trim spaces from company names, standardize industry names, and fix inconsistencies.
5. Handle Null Values: Fill null values appropriately and remove irrelevant records.
6. Final Verification: Ensure the final dataset is clean and ready for analysis by dropping unnecessary columns.
The complete SQL code and the steps taken for each cleaning operation can be found in the repository.

Challenges Faced
- Identifying and handling duplicates required careful consideration of various fields to ensure no relevant data was lost.
- Standardizing industry names posed challenges due to variations in naming conventions, necessitating manual checks and updates.
- Handling null values was complex, as some entries lacked crucial information, requiring thoughtful strategies to fill gaps without compromising data integrity.
- 
Outcomes
The final dataset is clean, consistent, and ready for analysis.
All duplicate entries have been removed.
The data has been standardized in terms of naming conventions and formats, ensuring uniformity across the dataset.

Usage
To execute the SQL queries and explore the cleaned dataset:
1. Clone the repository:

    git clone https://github.com/yourusername/Portfolio-Project-layoffs-data-cleaning-2024.git
3. Import the SQL files into your preferred database management system.
4. Follow the documented SQL queries to review and analyze the cleaned data. 

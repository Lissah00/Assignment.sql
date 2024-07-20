CREATE DATABASE llin_analysis;

USE llin_analysis;

CREATE TABLE llin_distribution (
id INT AUTO_INCREMENT PRIMARY KEY,
number_distributed INT NOT NULL,
location VARCHAR(255) NOT NULL,
country VARCHAR(255) NOT NULL,
year YEAR NOT NULL,
by_whom VARCHAR(255),
country_code VARCHAR(10)
);

SELECT * FROM llin_distribution;

-- DESCRIPTIVE STATS

-- TOTAL NO OF LLINS IN EACH COUNTRY

SELECT 
country, SUM(number_distributed) AS total_distributed
FROM
llin_distribution
GROUP BY country;

-- AVERAGE NO OF LLINS DISTRIBUTED PER DISTRIBUTION EVENT

SELECT
 AVG(number_distributed) AS average_distributed
FROM llin_distribution;

-- EARLIEST AND LATEST DISTRIBUTION DATES

SELECT
MIN(year) AS earliest_year, MAX(year) AS latest_year
FROM llin_distribution;

-- TRENDS AND PATTERNS

-- NO OF LLINS DISTRIBUTED BY EACH ORGANIZATION

SELECT 
    by_whom, 
    SUM(number_distributed) AS total_distributed
FROM 
    llin_distribution
GROUP BY 
    by_whom;
    
    -- TOTAL NUMBER OF LLINS DISTRIBUTED EACH YEAR
    
    SELECT 
    year, 
    SUM(number_distributed) AS total_distributed
FROM 
    llin_distribution
GROUP BY 
    year;
    
    -- VOLUME INSIGHTS
    
    -- HIGHEST AND LOWEST NO OF LLINS DISTRIBUTED
    SELECT 
    location, 
    SUM(number_distributed) AS total_distributed
FROM 
    llin_distribution
GROUP BY 
    location
ORDER BY 
    total_distributed DESC
LIMIT 1;

-- SIGNIFICANT DIFFERENCE IN THE NO OF LLINS DISTRIBUTED BY DIFFERENT ORGANIZATIONS

SELECT 
    location, 
    SUM(number_distributed) AS total_distributed
FROM 
    llin_distribution
GROUP BY 
    location
ORDER BY 
    total_distributed ASC
LIMIT 1;

SELECT 
    by_whom, 
    SUM(number_distributed) AS total_distributed
FROM 
    llin_distribution
GROUP BY 
    by_whom
ORDER BY 
    total_distributed DESC;
    
    -- IDENTIFY EXTREMES
-- Calculate the mean and standard deviation of LLINs distributed by location
    
    SELECT 
    AVG(total_distributed) AS mean_distributed,
    STDDEV(total_distributed) AS stddev_distributed
FROM (
    SELECT 
        location, 
        SUM(number_distributed) AS total_distributed
    FROM 
        llin_distribution
    GROUP BY 
        location
) AS location_stats;

-- Identify outliers by location

SELECT 
    location, 
    total_distributed,
    (total_distributed - mean_distributed) / stddev_distributed AS z_score
FROM (
    SELECT 
        location, 
        SUM(number_distributed) AS total_distributed
    FROM 
        llin_distribution
    GROUP BY 
        location
        
) AS location_stats,

(
-- Calculate mean and standard deviation of LLINs distributed by year
    SELECT 
        AVG(total_distributed) AS mean_distributed,
        STDDEV(total_distributed) AS stddev_distributed
    FROM (
        SELECT 
            location, 
            SUM(number_distributed) AS total_distributed
        FROM 
            llin_distribution
        GROUP BY 
            location
    ) AS location_stats
) AS stats
WHERE
    ABS((total_distributed - mean_distributed) / stddev_distributed) > 2;
    
    SELECT 
    year,
    AVG(total_distributed) AS mean_distributed,
    STDDEV(total_distributed) AS stddev_distributed
FROM (
    SELECT 
        year,
        SUM(number_distributed) AS total_distributed
    FROM 
        llin_distribution
    GROUP BY 
        year
) AS year_stats
GROUP BY
    year;
    
  -- Identify significant spikes by year 
  
    SELECT 
    year, 
    total_distributed,
    (total_distributed - mean_distributed) / stddev_distributed AS z_score
FROM (
    SELECT 
        year, 
        SUM(number_distributed) AS total_distributed
    FROM 
        llin_distribution
    GROUP BY 
        year
) AS year_stats,
(
    SELECT 
        AVG(total_distributed) AS mean_distributed,
        STDDEV(total_distributed) AS stddev_distributed
    FROM (
        SELECT 
            year, 
            SUM(number_distributed) AS total_distributed
        FROM 
            llin_distribution
        GROUP BY 
            year
    ) AS year_stats
) AS stats
WHERE
    ABS((total_distributed - mean_distributed) / stddev_distributed) > 2;


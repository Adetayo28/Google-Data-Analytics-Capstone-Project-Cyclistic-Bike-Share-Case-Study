-- Create DATABASE
CREATE DATABASE cyclistic_data;

-- Create TABLE
CREATE TABLE IF NOT EXISTS cyclistic_trip (
    ride_id VARCHAR(50) PRIMARY KEY,
    rideable_type VARCHAR(20),
    started_at TIMESTAMP,
    ended_at TIMESTAMP,
    start_station_name VARCHAR(100),
    start_station_id VARCHAR(50),
    end_station_name VARCHAR(100),
    end_station_id VARCHAR(50),
    start_lat NUMERIC,
    start_lng NUMERIC,
    end_lat NUMERIC,
    end_lng NUMERIC,
    member_casual VARCHAR(20)
);

SELECT *
FROM cyclistic_trip;

-- Count for total row
SELECT COUNT(*)
FROM cyclistic_trip;

-- Count by rideable_type
SELECT 
	rideable_type, 
	COUNT(*) AS Total_rideable_type
FROM cyclistic_trip
GROUP BY rideable_type;

-- Count by user type
SELECT 
	member_casual, 
	COUNT(*) AS Total_user_type
FROM cyclistic_trip
GROUP BY member_casual;

-- Check for nulls in important columns 
SELECT COUNT(*)
FROM cyclistic_trip
WHERE ride_id IS NULL
	OR rideable_type IS NULL
	OR started_at IS NULL
	OR ended_at IS NULL
	OR member_casual IS NULL;


/* check for null in full table 
SELECT 
    SUM(CASE WHEN ride_id IS NULL THEN 1 ELSE 0 END) AS ride_id_null,
    SUM(CASE WHEN rideable_type IS NULL THEN 1 ELSE 0 END) AS rideable_type_null,
    SUM(CASE WHEN started_at IS NULL THEN 1 ELSE 0 END) AS started_at_null,
    SUM(CASE WHEN ended_at IS NULL THEN 1 ELSE 0 END) AS ended_at_null,
    SUM(CASE WHEN start_station_name IS NULL THEN 1 ELSE 0 END) AS start_station_name_null,
    SUM(CASE WHEN start_station_id IS NULL THEN 1 ELSE 0 END) AS start_station_id_null,
    SUM(CASE WHEN end_station_name IS NULL THEN 1 ELSE 0 END) AS end_station_name_null,
    SUM(CASE WHEN end_station_id IS NULL THEN 1 ELSE 0 END) AS end_station_id_null,
    SUM(CASE WHEN start_lat IS NULL THEN 1 ELSE 0 END) AS start_lat_null,
    SUM(CASE WHEN start_lng IS NULL THEN 1 ELSE 0 END) AS start_lng_null,
    SUM(CASE WHEN end_lat IS NULL THEN 1 ELSE 0 END) AS end_lat_null,
    SUM(CASE WHEN end_lng IS NULL THEN 1 ELSE 0 END) AS end_lng_null,
    SUM(CASE WHEN member_casual IS NULL THEN 1 ELSE 0 END) AS member_casual_null
FROM cyclistic_trip;
*/


-- creating ride_length column

ALTER TABLE cyclistic_trip
ADD COLUMN ride_length INTERVAL;

UPDATE cyclistic_trip
SET ride_length = ended_at - started_at;


SELECT *
FROM cyclistic_trip;

-- creating ride duration in minutes column
ALTER TABLE cyclistic_trip
ADD COLUMN ride_min NUMERIC;

UPDATE cyclistic_trip
SET ride_min = ROUND(EXTRACT(EPOCH FROM ride_length) / 60, 2);


SELECT *
FROM cyclistic_trip;

-- creating time of day column each ride started
ALTER TABLE cyclistic_trip
ADD COLUMN time_of_day INT;

UPDATE cyclistic_trip
SET time_of_day = EXTRACT(hour FROM started_at);


SELECT *
FROM cyclistic_trip;

-- creating day of week column each ride happened
ALTER TABLE cyclistic_trip
ADD COLUMN day_of_week VARCHAR;

UPDATE cyclistic_trip
SET day_of_week = TO_CHAR(started_at, 'Day');


SELECT *
FROM cyclistic_trip;

-- creating ride year & month column

ALTER TABLE cyclistic_trip
ADD COLUMN ride_year_month VARCHAR;

UPDATE cyclistic_trip
SET ride_year_month = TO_CHAR(started_at, 'YYYY-MM');



SELECT *
FROM cyclistic_trip;

-- check for negative 

SELECT COUNT(*) AS negative_duration
FROM cyclistic_trip
WHERE ended_at < started_at;


-- Deleting nagative rides

DELETE FROM cyclistic_trip
WHERE ended_at < started_at;


-- check for rides shorter than 1 minutes
SELECT COUNT(*) AS too_short
FROM cyclistic_trip
WHERE ride_min < 1;

-- deleting rides shorter than 1 minute
DELETE FROM cyclistic_trip
WHERE ride_min < 1;


SELECT *
FROM cyclistic_trip;



-- Creation of Table for Analysis 
CREATE OR REPLACE VIEW cyclistic_analysis AS
SELECT 
    ride_id,
    member_casual,
    rideable_type,
    started_at,
    ended_at,
    ride_length,
    ride_min,
    day_of_week,
    time_of_day,
    ride_year_month
FROM cyclistic_trip;



SELECT *
FROM cyclistic_analysis;

-- Creation of Table for Heat Map
CREATE OR REPLACE VIEW cyclistic_geo_analysis AS
SELECT *
FROM cyclistic_trip
WHERE 
    start_station_name IS NOT NULL
    AND end_station_name IS NOT NULL
    AND start_lat IS NOT NULL
    AND start_lng IS NOT NULL
    AND end_lat IS NOT NULL
    AND end_lng IS NOT NULL;

SELECT *
FROM cyclistic_geo_analysis;
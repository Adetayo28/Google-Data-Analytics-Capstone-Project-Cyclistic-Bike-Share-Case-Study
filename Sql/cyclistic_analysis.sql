
-- BUSINESS QUESTION 1

-- Total Rides by User Type
SELECT 
	member_casual, 
	COUNT(*) AS total_rides
FROM cyclistic_analysis
GROUP BY member_casual;


-- Average Ride Duration by User Type
SELECT 
	member_casual, 
	ROUND(AVG(ride_min), 2) AS avg_ride_min
FROM cyclistic_analysis
GROUP BY member_casual;

-- Ride Count by Day of Week
SELECT member_casual, TRIM(day_of_week) AS day, COUNT(*) AS total_rides
FROM cyclistic_analysis
GROUP BY member_casual, day
ORDER BY member_casual, 
    CASE 
        WHEN TRIM(day_of_week) = 'Sunday' THEN 1
        WHEN TRIM(day_of_week) = 'Monday' THEN 2
        WHEN TRIM(day_of_week) = 'Tuesday' THEN 3
        WHEN TRIM(day_of_week) = 'Wednesday' THEN 4
        WHEN TRIM(day_of_week) = 'Thursday' THEN 5
        WHEN TRIM(day_of_week) = 'Friday' THEN 6
        WHEN TRIM(day_of_week) = 'Saturday' THEN 7
    END;

-- Bike Type Preferences
SELECT 
	member_casual, 
	rideable_type, 
	COUNT(*) AS ride_count
FROM cyclistic_analysis
GROUP BY member_casual, rideable_type
ORDER BY member_casual, ride_count DESC;

-- Ride Distribution by Time of Day
SELECT 
	member_casual, 
	time_of_day, 
	COUNT(*) AS total_rides
FROM cyclistic_analysis
GROUP BY member_casual, time_of_day
ORDER BY member_casual, time_of_day;


-- Ride Distribution by Monthly 
SELECT 
    ride_year_month,
    member_casual,
    rideable_type,
    COUNT(*) AS ride_count
FROM cyclistic_analysis
GROUP BY ride_year_month, member_casual, rideable_type
ORDER BY ride_year_month, member_casual, rideable_type;


SELECT * 
FROM cyclistic_analysis;


/* BUSINESS QUESTION 2
Why would casual riders buy Cyclistic annual memberships?
*/

-- Casual Riders by Frequency
SELECT 
	ride_year_month, 
	COUNT(*) AS total_rides
FROM cyclistic_analysis
WHERE member_casual = 'casual'
GROUP BY ride_year_month
ORDER BY ride_year_month;

-- Average Ride Duration by Day for Casual Riders

SELECT 
	TRIM(day_of_week) AS day, 
	ROUND(AVG(ride_min), 2) AS avg_duration
FROM cyclistic_analysis
WHERE member_casual = 'casual'
GROUP BY day
ORDER BY 
    CASE 
        WHEN TRIM(day_of_week) = 'Sunday' THEN 1
        WHEN TRIM(day_of_week) = 'Monday' THEN 2
        WHEN TRIM(day_of_week) = 'Tuesday' THEN 3
        WHEN TRIM(day_of_week) = 'Wednesday' THEN 4
        WHEN TRIM(day_of_week) = 'Thursday' THEN 5
        WHEN TRIM(day_of_week) = 'Friday' THEN 6
        WHEN TRIM(day_of_week) = 'Saturday' THEN 7
    END;




/* BUSINESS QUESTION 3
How can Cyclistic use digital media 
to influence casual riders to become members?
*/

-- Casual Rider Volume by Time of Day
SELECT 
	time_of_day, 
	COUNT(*) AS total_rides
FROM cyclistic_analysis
WHERE member_casual = 'casual'
GROUP BY time_of_day
ORDER BY time_of_day;





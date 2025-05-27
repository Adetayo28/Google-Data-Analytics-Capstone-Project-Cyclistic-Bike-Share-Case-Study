/* BUSINESS QUESTION 3
How can Cyclistic use digital media 
to influence casual riders to become members?
*/

-- Top 10 Start Stations for Casual Riders (Geo Insight)

SELECT 
	start_station_name, 
	COUNT(*) AS total_rides
FROM cyclistic_geo_analysis
WHERE member_casual = 'casual'
GROUP BY start_station_name
ORDER BY total_rides DESC
LIMIT 10;


-- Casual Rider Volume by Time of Day
SELECT 
	time_of_day, 
	COUNT(*) AS total_rides
FROM cyclistic_analysis
WHERE member_casual = 'casual'
GROUP BY time_of_day
ORDER BY time_of_day;



-- Ride Counts by Bike Type Per Month
SELECT 
    ride_year_month,
    rideable_type,
    COUNT(*) AS ride_count
FROM cyclistic_analysis
GROUP BY ride_year_month, rideable_type
ORDER BY ride_year_month, rideable_type;


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

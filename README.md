
# Cyclistic Bike-Share Capstone Project

## Project Overview

This project is a comprehensive analysis of historical bike-share data from **Cyclistic**, a fictional bike-share program based in Chicago. Conducted as part of the **Google Data Analytics Capstone Project**, following the **Ask-Prepare-Process-Analyze-Share-Act** framework. The goal was to uncover behavioral trends between **casual riders** and **annual members** to help the marketing team develop a data-driven strategy for increasing annual subscriptions.


---

## ASK

### Business Task: 

Analyze how casual riders and annual members use Cyclistic bikes differently and provide insights and recommendations that can help **convert more casual riders into annual members**.

### Business Questions:

1. How do annual members and casual riders use Cyclistic bikes differently?
2. Why would casual riders buy Cyclistic annual memberships?
3. How can Cyclistic use digital media to influence casual riders to become members?

---

## PREPARE

## Data Source:

Cyclistic provides open-access trip data through the following source:  
[https://divvy-tripdata.s3.amazonaws.com/index.html](https://divvy-tripdata.s3.amazonaws.com/index.html)

The raw Cyclistic dataset consisted of 12 monthly CSV files spanning March 2024 to February 2025, totaling **5,783,100** rows.

--- 
## Tools Used

| Tool | Purpose |
|------|---------|
| **Excel** | Exploratory data review |
| **PowerShell** | Deduplication & automation of data import |
| **PostgreSQL** | Exploration, cleaning & transformation |
| **Tableau** | Data visualization and interactive dashboard |



---

## PROCESS

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `cyclistic_data`.
- **Table Creation**: A table named `cyclistic_trip` is created to store the ride data. The table structure includes columns for ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual.

```sql

-- create DATABASE
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
```

### Data Exploration and Cleaning
- Created a PowerShell-based ETL script to:
  - Pre-clean duplicates
  - Log skipped `ride_id`s
  - Import cleaned data into the database
- Removed **211 duplicate rows** based on `ride_id`
- Final dataset imported into PostgresSQL: **5,782,889 rows**
- Cleaned nulls:
  - Filtered out **202 rides with negative durations**
  - Filtered out **128,407 rides under 1 minute**
  - Retained rows with missing station names (still valuable for behavior analysis)
- Created additional columns:
  - `ride_length_min`: ride duration in minutes
  - `day_of_week`: weekday name 
  - `time_of_day`: time of ride during the day
  - `ride_year_month`: year and month of ride 
- Exported final datasets as CSVs for Tableau:
  - `cyclistic_analysis.csv`
  - `cyclistic_geo_analysis.csv`  


---

## ANLAYSIS

### Ride Frequency by User Type
- Members take **1.5x more rides** than casual users (3.58M vs 2.06M)

```sql

SELECT 
	member_casual, 
	COUNT(*) AS total_rides
FROM cyclistic_trip
GROUP BY member_casual;

```
 
### Ride Duration by User Type
- Casual riders ride **twice as long** on average (25.68 mins vs 12.77 mins)

```sql

SELECT 
	member_casual, 
	ROUND(AVG(ride_min), 2) AS avg_ride_min
FROM cyclistic_trip
GROUP BY member_casual;
```

### Time of Day & Day of Week Patterns
- Members are **weekday commuters**, especially **Tues-Thurs, 8-9 AM & 5-6 PM**
- Casual riders are **Weekend-heavy user (Sat & Sun)** and take **longer rides**, mainly during midday and for leisure.

```sql

	SELECT 
	member_casual, 
	time_of_day, 
	COUNT(*) AS total_rides
FROM cyclistic_trip
GROUP BY member_casual, time_of_day
ORDER BY member_casual, time_of_day;
```

```sql

SELECT member_casual, TRIM(day_of_week) AS day, COUNT(*) AS total_rides
FROM cyclistic_trip
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
```


### Bike Type Preferences
- Both groups favor **electric bikes**
- Scooters are rarely used but slightly more popular with casuals

```sql

SELECT 
	member_casual, 
	rideable_type, 
	COUNT(*) AS ride_count
FROM cyclistic_trip
GROUP BY member_casual, rideable_type
ORDER BY member_casual, ride_count DESC;
```


### Bonus Insight - Popular Start Stations
- Identified top 10 most-used starting stations by rider type
  - Start station clusters differ:
    - Casuals: near **parks, tourist zones, lakefront**
    - Members: near **workplaces and residential hubs**
- Useful for geo-targeted marketing and partnerships

---

## SHARE  

**Dashboard Tool:** Tableau  
**Dashboard Dimensions:** 1200px × 1500px

**Dashboard Features:**
- User type split
- Monthly and weekly ride trends
- Hourly usage pattern
- Average ride duration
- Top start stations (casual riders)
- Geospatial heat map
- Key insights and strategic recommendations in footer

**Exported Deliverables:**
- `Cyclistic_viz.pdf` – PDF of full dashboard
- 🔗 [View Tableau Dashboard](https://public.tableau.com/app/profile/adetayo.akinsola/viz/Cyclistic_viz_17481887411890/CyclisticDashboard)
- README documentation

---

## ACT

### Strategic Recommendation:

**Convert casual riders to members with cost/time-saving offers.**

**Tactics Include:**
- Seasonal promotions during peak months
- Loyalty-based email nudges
- Time-saving features like fast checkouts
- Bundled experiences with leisure perks

> These actions support Cyclistic's business goal of boosting annual memberships and ensuring long-term revenue growth.

---

## Key Takeaways

This analysis provides clear evidence that casual riders and members behave differently. By understanding these differences, Cyclistic can design **targeted, evidence-based marketing strategies** to grow its loyal customer base.

---

## Learnings & Reflections

- Built a full ETL pipeline using PowerShell
- Learned how to handle large datasets in PostgreSQL
- Transformed SQL queries into meaningful Tableau visuals
- Gained practical experience in business-oriented storytelling with data


## Author

**Adetayo**  
Data Analyst | Teach for Nigeria Fellow  
[LinkedIn](www.linkedin.com/in/adetayo-akinsola) | [Tableau Profile](https://public.tableau.com/app/profile/adetayo.akinsola/vizzes) | [GitHub](https://github.com/Adetayo28)

---

*Inspired by the Google Data Analytics Capstone (Case Study #1)*

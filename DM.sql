GENERAL STATISTICS

#Resume database
SELECT *
FROM FacebookInsights_csv fic 


#How many engaged users did the page have in the given time period?
SELECT
SUM(Engaged_Users) as N_Engaged_Users
FROM FacebookInsights_csv fic 

#What is the average reach of the page's posts over the given time period?
SELECT
SUM(Reach) / COUNT(*) as Av_Reach
FROM FacebookInsights_csv fic 

#Enagagement rate
SELECT
((SUM(Engaged_Fans) + SUM(Engaged_Users))/Sum(Reach))*100  as Engagement_Rate
FROM FacebookInsights_csv fic 


# Top 10 country codes (based on maximum number of fans) 
SELECT CountryCode,
SUM(NumberOfFans) as Country_Code
FROM FansPerCountry_csv fpcc 
Group By CountryCode 
ORDER BY  Country_Code DESC
LIMIT 10

#Top 10 countries (based on penetration rate: % of a country's inhabitants who are fans) 
SELECT CountryCode,
(SUM(NumberOfFans)/(SELECT Sum(NumberOfFans) FROM FansPerCountry_csv fpcc ))*100 as Fans_Rate_ByCountry
FROM FansPerCountry_csv fpcc 
Group By CountryCode 
ORDER BY Fans_Rate_ByCountry DESC 
LIMIT 10

STATITICS BY CITY 

#Top 10 countries (based on penetration rate: % of a country's inhabitants who are fans) 
SELECT ccc.City, fpcc.NumberOfFans 
FROM Population_csv pc 
JOIN CityCountry_csv ccc on ccc.CountryCode = pc.CountryCode 
JOIN FansPerCity_csv fpcc on ccc.City = fpcc.City 
WHERE pc.Population > 20000000
GROUP by ccc.City 
ORDER By fpcc.NumberOfFans  
LIMIT 10

STATISTICS BY AGE AND SEX

#Fans by age group
SELECT Age, 
(SUM(NumberOfFans)/(SELECT SUM(NumberOfFans) 
FROM FansPerGenderAge_csv fpgac))*100  as Number_fans
FROM FansPerGenderAge_csv fpgac 
GROUP BY Age 
ORDER by Number_fans DESC 

#Fans by sex
SELECt Gender,
(SUM(NumberOfFans)/(SELECT SUM(NumberOfFans) 
FROM FansPerGenderAge_csv fpgac))*100  as Number_fans
FROM FansPerGenderAge_csv fpgac 
GROUP BY Gender 
ORDER by Number_fans DESC 

#Nomber of date
SELECT SexeAge,
COUNT(Date) as N_days 
FROM FansPerGenderAge_csv fpgac 
Group By SexeAge 

TIME COMITTEMENT 

#What is the breakdown of post engagement by day of the week (Monday, Tuesday,...)?
SELECT 
CASE 
    WHEN DAYOFWEEK(DATE(STR_TO_DATE(created_time, '%d/%m/%Y %H:%i:%s'))) = 1 THEN 'Sunday'
    WHEN DAYOFWEEK(DATE(STR_TO_DATE(created_time, '%d/%m/%Y %H:%i:%s'))) = 2 THEN 'Monday'
    WHEN DAYOFWEEK(DATE(STR_TO_DATE(created_time, '%d/%m/%Y %H:%i:%s'))) = 3 THEN 'Tuesday'
    WHEN DAYOFWEEK(DATE(STR_TO_DATE(created_time, '%d/%m/%Y %H:%i:%s'))) = 4 THEN 'Wednesday'
    WHEN DAYOFWEEK(DATE(STR_TO_DATE(created_time, '%d/%m/%Y %H:%i:%s'))) = 5 THEN 'Thursday'
    WHEN DAYOFWEEK(DATE(STR_TO_DATE(created_time, '%d/%m/%Y %H:%i:%s'))) = 6 THEN 'Friday'
    WHEN DAYOFWEEK(DATE(STR_TO_DATE(created_time, '%d/%m/%Y %H:%i:%s'))) = 7 THEN 'Saturday'
  END AS Days_of_week,
   ((SUM(Engaged_Fans) + SUM(Engaged_Users))/Sum(Reach))*100  as Engagement_Rate
FROM 
  FacebookInsights_csv fic 
GROUP BY 
  Days_of_week
ORDER BY 
  Engagement_Rate DESC;
 
 #What is the best day of the week to publish posts?
 SELECT 
CASE 
    WHEN DAYOFWEEK(DATE(STR_TO_DATE(created_time, '%d/%m/%Y %H:%i:%s'))) = 1 THEN 'Sunday'
    WHEN DAYOFWEEK(DATE(STR_TO_DATE(created_time, '%d/%m/%Y %H:%i:%s'))) = 2 THEN 'Monday'
    WHEN DAYOFWEEK(DATE(STR_TO_DATE(created_time, '%d/%m/%Y %H:%i:%s'))) = 3 THEN 'Tuesday'
    WHEN DAYOFWEEK(DATE(STR_TO_DATE(created_time, '%d/%m/%Y %H:%i:%s'))) = 4 THEN 'Wednesday'
    WHEN DAYOFWEEK(DATE(STR_TO_DATE(created_time, '%d/%m/%Y %H:%i:%s'))) = 5 THEN 'Thursday'
    WHEN DAYOFWEEK(DATE(STR_TO_DATE(created_time, '%d/%m/%Y %H:%i:%s'))) = 6 THEN 'Friday'
    WHEN DAYOFWEEK(DATE(STR_TO_DATE(created_time, '%d/%m/%Y %H:%i:%s'))) = 7 THEN 'Saturday'
  END AS Days_of_week,
   ((SUM(Engaged_Fans) + SUM(Engaged_Users))/Sum(Reach))*100  as Engagement_Rate
FROM 
  FacebookInsights_csv fic 
GROUP BY 
  Days_of_week
ORDER BY 
  Engagement_Rate DESC;
 
 #What is the distribution of post engagement by time of day?
SELECT 
  CASE 
    WHEN FLOOR(HOUR(STR_TO_DATE(created_time, '%d/%m/%Y %H:%i:%s')) / 2) * 2 BETWEEN 0 AND 2 THEN '0-2'
    WHEN FLOOR(HOUR(STR_TO_DATE(created_time, '%d/%m/%Y %H:%i:%s')) / 2) * 2 BETWEEN 2 AND 4 THEN '2-4'
    WHEN FLOOR(HOUR(STR_TO_DATE(created_time, '%d/%m/%Y %H:%i:%s')) / 2) * 2 BETWEEN 4 AND 6 THEN '4-6'
    WHEN FLOOR(HOUR(STR_TO_DATE(created_time, '%d/%m/%Y %H:%i:%s')) / 2) * 2 BETWEEN 6 AND 8 THEN '6-8'
    WHEN FLOOR(HOUR(STR_TO_DATE(created_time, '%d/%m/%Y %H:%i:%s')) / 2) * 2 BETWEEN 8 AND 10 THEN '8-10'
    WHEN FLOOR(HOUR(STR_TO_DATE(created_time, '%d/%m/%Y %H:%i:%s')) / 2) * 2 BETWEEN 10 AND 12 THEN '10-12'
    WHEN FLOOR(HOUR(STR_TO_DATE(created_time, '%d/%m/%Y %H:%i:%s')) / 2) * 2 BETWEEN 12 AND 14 THEN '12-14'
    WHEN FLOOR(HOUR(STR_TO_DATE(created_time, '%d/%m/%Y %H:%i:%s')) / 2) * 2 BETWEEN 14 AND 16 THEN '14-16'
    WHEN FLOOR(HOUR(STR_TO_DATE(created_time, '%d/%m/%Y %H:%i:%s')) / 2) * 2 BETWEEN 16 AND 18 THEN '16-18'
    WHEN FLOOR(HOUR(STR_TO_DATE(created_time, '%d/%m/%Y %H:%i:%s')) / 2) * 2 BETWEEN 18 AND 20 THEN '18-20'
    WHEN FLOOR(HOUR(STR_TO_DATE(created_time, '%d/%m/%Y %H:%i:%s')) / 2) * 2 BETWEEN 20 AND 22 THEN '20-22'
    WHEN FLOOR(HOUR(STR_TO_DATE(created_time, '%d/%m/%Y %H:%i:%s')) / 2) * 2 BETWEEN 22 AND 24 THEN '22-24'
  END AS 2_hour_intervals,
  ((SUM(Engaged_Fans) + SUM(Engaged_Users))/Sum(Reach))*100  as Engagement_Rate
FROM 
  FacebookInsights_csv fic 
GROUP BY 
  2_hour_intervals
ORDER BY 
  Engagement_Rate DESC;

  
  

 

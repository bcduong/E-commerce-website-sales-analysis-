#Statistiques generales


#1. Combien la page a-t-elle enregistré d'utilisateurs engagés au cours de la période donnée ?
SELECT 
	SUM(Engaged_Users) as total_users
from FacebookInsights_csv fic 

#2. Quelle est la portée moyenne des posts de la page sur la période donnée ?
SELECT 
	AVG (Reach) as Portee_moyenne
FROM FacebookInsights_csv fic 

#3.Quel est le taux d'engagement moyen sur la page sur la période donnée ?
SELECT
	((SUM(Engaged_Fans)+ SUM(Engaged_Users))/SUM(Reach))*100 as taux_engagement
FROM FacebookInsights_csv fic 

#Statistiques par pays

#Quels sont les 10 premiers codes pays (au vu du nombre maximum de fans) ?
SELECT 
	DISTINCT CountryCode, SUM(NumberOfFans) AS Total_fans_par_pays
FROM FansPerCountry_csv fpcc 
GROUP BY CountryCode
ORDER BY NumberOfFans DESC
LIMIT 10


#Quels sont les 10 premiers pays (au vu du taux de pénétration : % d'habitants d'un pays qui sont fans) ?

SELECT pc.CountryName, (fpcc_totals.Total_fans_par_pays / pc.Population)*100 AS taux_penetration
FROM 
	(SELECT DISTINCT fpcc.CountryCode, SUM(NumberOfFans) AS Total_fans_par_pays
	FROM FansPerCountry_csv fpcc 
	GROUP BY fpcc.CountryCode) AS fpcc_totals
	INNER JOIN Population_csv pc ON fpcc_totals.CountryCode = pc.CountryCode
GROUP BY fpcc_totals.CountryCode 
ORDER BY taux_penetration DESC
LIMIT 10


#Stats par ville

#Quelles sont les 10 villes les moins importantes (au vu du nombre de fans) parmi les pays comprenant plus de 20 millions d'habitants ? Elles peuvent être considérées comme le potentiel de croissance


SELECT fpct.City, fpct.NumberOfFans 
FROM FansPerCity_csv fpct 
	JOIN CityCountry_csv ccc 
	ON ccc.City = fpct.City 
	JOIN Population_csv pc 
	ON ccc.CountryCode =pc.CountryCode 
WHERE pc.Population > 20000000
GROUP BY fpct.City 
ORDER BY fpct.NumberOfFans DESC
LIMIT 10

#Analyse par sexe et tranche d'âge
#Quelle est la répartition des fans de la page par tranche d'âge (en pourcentage) ?
SELECT  fpgac.Age, SUM(fpgac.NumberOfFans)/ (SELECT SUM(fpgac.NumberOfFans)
 FROM FansPerGenderAge_csv fpgac)*100
FROM FansPerGenderAge_csv fpgac 
GROUP BY fpgac.Age 

#Quelle est la répartition des fans de la page par sexe (en pourcentage) ?
SELECT  fpgac.Gender , SUM(fpgac.NumberOfFans)/ (SELECT SUM(fpgac.NumberOfFans)
 FROM FansPerGenderAge_csv fpgac)*100
FROM FansPerGenderAge_csv fpgac 
GROUP BY fpgac.Gender  

#Disposons-nous du même nombre de jours pour tous les sexes et tranches d'âge ?
SELECT COUNT(DISTINCT Date(fpgac.Date_Time))
FROM FansPerGenderAge_csv fpgac

#Quelle est la répartition du taux d'engagement des posts selon les jours de la semaine (lundi, mardi,...) ?
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
   ((SUM(Engaged_Fans)+ SUM(Engaged_Users))/SUM(Reach))*100 as taux_engagement
FROM 
  FacebookInsights_csv fic 
GROUP BY 
  Days_of_week
ORDER BY 
  Days_of_week DESC  ;


#Quelle est la répartition du taux d'engagement des posts selon les heures de la journée ?
SELECT HOUR(STR_TO_DATE(fic.created_time, '%d/%m/%Y %H:%i:%s')) AS hour,  ((SUM(Engaged_Fans)+ SUM(Engaged_Users))/SUM(Reach))*100 as taux_engagement
FROM FacebookInsights_csv fic
GROUP BY hour
ORDER BY taux_engagement  DESC

#Quelle est la meilleure heure de la journée pour publier des posts ?
SELECT HOUR(STR_TO_DATE(fic.created_time, '%d/%m/%Y %H:%i:%s')) AS hour, fic.Reach 
FROM FacebookInsights_csv fic 
GROUP BY hour 
ORDER BY fic.Reach DESC
 
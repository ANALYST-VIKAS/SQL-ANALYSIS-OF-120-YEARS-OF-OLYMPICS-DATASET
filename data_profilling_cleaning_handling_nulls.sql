-- DEALING WITH NULL VALUES OF age COLUMN
-- REPLACED THE NULL VALUES WITH THE AVERAGE AGE PLAYERS OF RESPECTIVE SPORTS 
UPDATE athlete_events AT
JOIN 
(
SELECT sport,ROUND(AVG(age),0) AS avg_age
FROM (
SELECT 	sport, age 
FROM athlete_events
WHERE sport IN (SELECT distinct sport FROM athlete_events WHERE age IS NULL) 
AND
age IS NOT NULL
) AA
GROUP BY 1
) A  ON A.sport = AT.sport
SET AT.age=avg_age
WHERE age IS NULL;
-- ---------------------------------------------------------------------------------------------------------------------------------
-- DEALING WITH NULL VALUES OF weight COLUMN
-- REPLACED THE NULL VALUES WITH THE AVERAGE weight OF PLAYERS OF RESPECTIVE SPORTS 
UPDATE athlete_events AT 
JOIN 
(
SELECT sport, ROUND(AVG(weight),0) AS avg_weight FROM athlete_events
WHERE sport IN (SELECT DISTINCT sport FROM athlete_events WHERE weight IS NULL)
AND
weight IS NOT NULL
GROUP BY 1
) W ON W.sport= AT.sport
SET weight = avg_weight
WHERE weight IS NULL;
-- ----------------------------------------------------------------------------------------------------------------------------------
-- DEALING WITH NULL VALUES OF height COLUMN
-- REPLACED THE NULL VALUES WITH THE AVERAGE height OF PLAYERS OF RESPECTIVE SPORTS 
UPDATE athlete_events AT 
JOIN 
(
SELECT sport,ROUND(AVG(height),0) AS avg_height FROM athlete_events
WHERE sport IN( SELECT DISTINCT sport FROM athlete_events WHERE height IS NULL)
AND weight IS NOT NULL
GROUP BY 1
) H ON H.sport=AT.sport 
SET height=avg_height
WHERE height IS NULL;

SELECT * FROM athlete_events;
-- -------------------------------------------------------------------------------------------------------------------------------
-- FURTHER DATA CLEANING AND CHECKING
SELECT DISTINCT sex from athlete_events; -- CONTAINS ONLY M AND F.

SELECT * FROM athlete_events;
SELECT * FROM noc_regions;

SELECT COUNT(DISTINCT noc) FROM noc_regions; -- 230 
SELECT COUNT( noc) FROM noc_regions; -- 230 NO DUPLICATES IN noc_regions

SELECT COUNT(DISTINCT NOC) FROM athlete_events; -- 230 

SELECT DISTINCT season from athlete_events; -- CONTAINS SUMMER AND WINTER.
-- --------------------------------------------------------------------------------------------------------------------------------
    SELECT * FROM  athlete_events;
	SELECT * FROM  noc_regions;
    
    SELECT AT.NOC,NR.noc,region
    FROM athlete_events AT LEFT JOIN
    noc_regions NR on NR.noc=AT.NOC
    WHERE NR.noc IS NULL;  -- NOC="SGP" AS SINGAPORE IN athlete_events 
    
	SELECT AT.NOC,NR.noc,region
    FROM athlete_events AT RIGHT JOIN
    noc_regions NR on NR.noc=AT.NOC
    WHERE AT.NOC IS NULL;  -- noc="SIN" AS SINGAPORE IN noc_regions
    
    UPDATE noc_regions
    SET noc="SGP"
    WHERE noc="SIN";
    
-- --------------------------------------------------------------------------------------------------------------------------------
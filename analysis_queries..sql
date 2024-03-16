-- ----------------------------------------------------------------------------------------------------------------------------------
-- How many Olympic games have been held?
	SELECT COUNT(DISTINCT games) AS No_of_olympic_games 
    FROM athlete_events;
    
-- List down all Olympic games held so far.
	SELECT DISTINCT games,season,city 
	FROM athlete_events
	order by 1;
    


-- Mention the total number of nations that participated in each Olympic game
    SELECT games,COUNT(DISTINCT AT.NOC) AS Total_no_of_nations_participated
    FROM athlete_events AT JOIN
    noc_regions NR ON NR.noc=AT.NOC
    GROUP BY 1
    ORDER BY 1;

-- Which year saw the highest and lowest number of countries participating in the Olympics?
	(
    SELECT CONCAT("Highest","-",games) AS no_games,
    COUNT(DISTINCT NOC) AS No_of_countries_participating
    FROM athlete_events
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 1
    )
    UNION ALL
    (
	SELECT CONCAT("LOWEST","-",games) AS no_games,
    COUNT(DISTINCT NOC) AS No_of_countries_participating
    FROM athlete_events
    GROUP BY 1
    ORDER BY 2 ASC
    LIMIT 1
    );
-- Which nation has participated in all of the Olympic games?
    
	SELECT AT.NOC,region AS Nations,
    COUNT(DISTINCT games) AS No_of_olympic_games_till_date
    FROM athlete_events AT JOIN
    noc_regions NR ON NR.noc=AT.NOC
    GROUP BY 1,2
    HAVING COUNT(DISTINCT games)=(SELECT COUNT(DISTINCT games) FROM athlete_events);
    
-- Identify the sport played in all Summer Olympics.
	SELECT DISTINCT SPORT 
    FROM athlete_events
    WHERE season="Summer";
    
-- Which sports were played only once in the Olympics Seasons?
	SELECT sport,COUNT(DISTINCT games) AS no_of_times_played
    FROM athlete_events
    GROUP BY 1
    HAVING COUNT(DISTINCT games)=1;
    
-- Fetch the total number of sports played in each Olympic game.
	
    SELECT games,COUNT(DISTINCT sport) AS no_of_sports_played 
    FROM athlete_events
    GROUP BY 1;
-- Fetch details of the oldest athletes to win a gold medal.
	WITH CTE AS
    (
    SELECT * FROM athlete_events
    WHERE medal="Gold" 
    )
	SELECT * FROM CTE
    WHERE age=(SELECT MAX(age) FROM CTE);
-- Find the ratio of male and female athletes participating in all Olympic games.
   SELECT 
   CONCAT
   (
	   "1",
	   ":",
		ROUND(
        (SELECT COUNT(sex) FROM athlete_events WHERE sex="F")/
		(SELECT COUNT(sex) FROM athlete_events WHERE sex="M")
			 ),2
	) AS Ratio_of_male_to_female;
-- Fetch the top 5 athletes who have won the most gold medals
	SELECT name,no_of_gold_medals FROM
    (
		WITH CTE AS(
			SELECT name,COUNT(*) AS no_of_gold_medals
			FROM athlete_events
			WHERE medal="Gold"
			GROUP BY 1
					)
		SELECT *,DENSE_RANK() OVER(ORDER BY no_of_gold_medals DESC) AS d_rank
		FROM CTE
    ) T
    WHERE d_rank<6;
-- Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
	SELECT name,total_medals FROM
    (
		WITH CTE AS(
			SELECT name,COUNT(medal) AS total_medals
			FROM athlete_events
            WHERE medal <> "NA"
			GROUP BY 1
					)
		SELECT *,DENSE_RANK() OVER(ORDER BY total_medals DESC) AS d_rank
		FROM CTE
    ) T
    WHERE d_rank<6;
  --  Fetch the top 5 most successful countries in the Olympics based on the number of medals won.
		SELECT region,total_medals
        FROM
        (
		WITH CTE AS(
        SELECT region,COUNT(medal) AS total_medals
        FROM athlete_events AT JOIN
        noc_regions NR ON NR.noc=AT.NOC
        WHERE medal <>"NA"
        GROUP BY 1
        )
        SELECT *,DENSE_RANK() OVER(ORDER BY total_medals DESC) AS d_rank
        FROM  CTE
        ) T
        WHERE d_rank <6;
        
-- List down total gold, silver, and bronze medals won by each country.
	SELECT region,
    SUM(CASE WHEN medal="Gold" THEN 1 ELSE 0 END) AS gold_medals,
    SUM(CASE WHEN medal="Silver" THEN 1 ELSE 0 END) AS Silver_medals,
    SUM(CASE WHEN medal="Bronze" THEN 1 ELSE 0 END) AS Bronze_medals
    FROM athlete_events AT JOIN
    noc_regions NR ON NR.noc=AT.NOC
    GROUP BY 1;
-- List down total gold, silver, and bronze medals won by each country corresponding to each Olympic game
	SELECT games,region,
    SUM(CASE WHEN medal="Gold" THEN 1 ELSE 0 END) AS gold_medals,
    SUM(CASE WHEN medal="Silver" THEN 1 ELSE 0 END) AS Silver_medals,
    SUM(CASE WHEN medal="Bronze" THEN 1 ELSE 0 END) AS Bronze_medals
    FROM athlete_events AT JOIN
    noc_regions NR ON NR.noc=AT.NOC
    GROUP BY games,region
    ORDER BY games;
-- Identify which country won the most gold, silver, and bronze medals in each Olympic game.
	WITH CTE AS(
    SELECT T1.games,T1.region AS R1,T1.Gold_medals AS most_Golds,
		   T2.region AS R2,T2.Silver_medals AS most_Silvers,T3.region AS R3,
           T3.Bronze_medals AS most_Bronzes
    FROM
   (
    SELECT games,region,gold_medals
    FROM(
	WITH CTE AS (
	SELECT games,region,COUNT(medal) AS gold_medals
	FROM athlete_events AT JOIN
    noc_regions NR ON NR.noc=AT.NOC
    WHERE medal ="Gold"
    GROUP BY 1,2
    )
    SELECT *,DENSE_RANK() OVER( PARTITION BY games ORDER BY gold_medals DESC) AS d_rank
    FROM CTE
    ) a
    WHERE d_rank =1
    ) T1 JOIN
    (    
    SELECT games,region,silver_medals
    FROM(
	WITH CTE AS (
	SELECT games,region,COUNT(medal) AS silver_medals
	FROM athlete_events AT JOIN
    noc_regions NR ON NR.noc=AT.NOC
    WHERE medal ="Silver"
    GROUP BY 1,2
    )
    SELECT *,DENSE_RANK() OVER( PARTITION BY games ORDER BY Silver_medals DESC) AS d_rank
    FROM CTE
    ) a
    WHERE d_rank =1
    ) T2 ON T1.games = T2.games JOIN
    (    
	SELECT games,region,Bronze_medals
    FROM(
	WITH CTE AS (
	SELECT games,region,COUNT(medal) AS Bronze_medals
	FROM athlete_events AT JOIN
    noc_regions NR ON NR.noc=AT.NOC
    WHERE medal ="Bronze"
    GROUP BY 1,2
    )
    SELECT *,DENSE_RANK() OVER( PARTITION BY games ORDER BY Bronze_medals DESC) AS d_rank
    FROM CTE
    ) a
    WHERE d_rank =1
    )
    T3 ON T3.games=T2.games
    )
    SELECT games,
			CONCAT(R1,' ','-',CAST(most_Golds AS CHAR)) MOST_GOLD,
			CONCAT(R2,' ','-',CAST(most_Silvers AS CHAR)) MOST_SILVER,
			CONCAT(R3,' ','-',CAST(most_Bronzes AS CHAR)) MOST_BRONZE
	FROM CTE;
-- Which countries have never won a gold medal but have won silver/bronze medals?
   SELECT region FROM noc_regions
   WHERE noc IN (
				SELECT DISTINCT NOC FROM athlete_events
				WHERE NOC NOT IN (SELECT DISTINCT NOC FROM athlete_events 
								  WHERE medal = "Gold" )  
                AND 
                medal <> "NA"
                );
-- In which Sport/event did India win the highest number of medals?
	SELECT sport,COUNT(medal) AS Total_medals FROM athlete_events
    WHERE NOC="IND" AND medal<>"NA"
    GROUP BY 1
    ORDER BY 2 DESC;
-- List down the percentage contribution in medals in INDIA due to sport HOCKEY in each Olympic game.
	WITH CTE AS
    (
	SELECT games,
    SUM(CASE WHEN sport="Hockey" THEN 1 ELSE 0 END) AS Hockey_medals,
    COUNT(medal) AS Total_medals
    FROM athlete_events
    WHERE NOC="IND" AND medal <> "NA"
    GROUP BY 1
    ORDER BY 1
    )
 SELECT *,ROUND(Hockey_medals*100/Total_medals,1) AS  pct_contribution
 FROM CTE;
-- LIST THE COUNTRIES WHERE FEMALE  PARTICIPANTS ARE MORE THAN MALE  PARTICIPANTS
	SELECT * FROM 
    (
    SELECT region,
    SUM(CASE WHEN sex="F" THEN 1 ELSE 0 END) AS Female_athletes,
    SUM(CASE WHEN sex="M" THEN 1 ELSE 0 END) AS Male_athletes    
    FROM athlete_events AT JOIN 
    noc_regions NR ON NR.noc=AT.NOC
    GROUP BY 1
    ) AA
    WHERE Female_athletes>Male_athletes;
-- LIST THE SPORTS WHERE FEMALES PERFORMED BETTER THAN MEN(IN TERMS OF MEDALS)
   SELECT * FROM 
   (
   SELECT sport,
    SUM(CASE WHEN sex= "F" AND medal <> "NA" THEN 1 ELSE 0 END) AS medals_by_female,
    SUM(CASE WHEN sex= "M" AND medal <> "NA" THEN 1 ELSE 0 END) AS medals_by_male
    FROM athlete_events
    GROUP BY 1
    ) AA
    WHERE medals_by_female>medals_by_male
    

    

 

    
    



  
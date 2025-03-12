
use project ;

--------------------------------------------------------------
# cleaning data and handling it

# REMOVE NULL AND SET OFF SQL SAFE AND ON IT 
SELECT `Hire Date` FROM hire
WHERE `Hire Date` IS NULL ;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM hire
WHERE `ï»¿Agent` AND`Hire Date` IS NULL;
DELETE FROM hire WHERE `ï»¿Agent` IS NULL OR TRIM(`ï»¿Agent`) = '';
select * from hire
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE survey DROP COLUMN Month;

ALTER TABLE survey
RENAME COLUMN `ï»¿Site Name` to site_name;

 #CONVERT HIRE_DATE FROM STRING IN TO DATE


------------------------------------------------------------------
# All calls responded.	

select ('Consult Outcom') ,count(*) as `All calls responded`
from aht
GROUP BY ('Consult Outcom')


# number_of issses did _every agent take              # by useing limit it be =top 10 agent take issuse
select Agent ,count('Case ID') as issues
from survey
group by Agent
order by issues DESC
limit 10;
-------------------------------------------------------------------------------------
# total num did every agent take and his hire date -
select s.Agent ,count("Case ID") as issues,h.`Hire Date`
from survey s
INNER JOIN hire H ON s.Agent=h.`ï»¿Agent`                       #here mean that employees which hire in past is lazy
group by s.agent, h.`hire Date`
order by issues desc
limit 10;                                         


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                                  -------------------------------------------------
															                        # stars 
# The agent and its total start.
select agent ,sum(`1 Star Count`)as `1 star`,
sum(`2 Star Count`) as `2 star`,
sum(`3 Star Count`) as `3 star`,
sum(`4 Star Count`) as `4 star`,
sum(`5 Star Count`) as `5 star`
from survey
group by agent; 

 
----------------------------------------------------------------
# top 10 agent with one start 
select agent ,sum(`1 Star Count`) as `1 star`
from survey
group by agent 
order by sum(`1 Star Count`) desc
limit 10;

-----------------------------
     # top 10 agent with 5 start                                                 # mean agent 3 agent is top rated 
select agent ,sum(`5 Star Count`) as `5 star`
from survey
group by agent                 
order by sum(`5 Star Count`) desc
limit 10

------------------------------------------

#issue  and its avg star rate 
SELECT a.`Consult Outcome`,  AVG(`CSAT Star Average`) AS "AVERAGE STAR RATE"
FROM aht as a 
JOIN survey as s ON a.`Case ID` = s.`Case ID`
GROUP BY a.`Consult Outcome`
ORDER BY AVG(`CSAT Star Average`) DESC;


------------------------------------------

# agent and its star( one and five ) percentage   

 select agent ,concat((sum(`1 Star Count`)  / (sum(`1 Star Count`) + sum(`2 Star Count`) + sum(`3 Star Count`) + sum(`4 Star Count`) + sum(`5 Star Count`)))*100,' ' ,'%')  as` percentage of 1 star`,
concat((sum(`5 Star Count`)  / (sum(`1 Star Count`) + sum(`2 Star Count`) + sum(`3 Star Count`) + sum(`4 Star Count`) + sum(`5 Star Count`)))*100,' ' ,'%') as` percentage of 5 star`
 from survey
group by agent 
order by concat((sum(`1 Star Count`)  / (sum(`1 Star Count`) + sum(`2 Star Count`) + sum(`3 Star Count`) + sum(`4 Star Count`) + sum(`5 Star Count`)))*100,' ' ,'%') desc
 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
													   ------------------------------------------ 
																	# solved issuse
     # who is the top agent which slove proplem 
         #  agent which slove proplem 
select agent, sum(`Helped Resolve Surveys`) as `solved problem` 
from survey
group by agent 
order by `solved problem`  desc; 

  # who is the top 10  agent which slove proplem 
  
select agent, sum(`Helped Resolve Surveys`) as `solved problem` 
from survey
group by agent 
order by `solved problem`  desc
limit 10 ;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
																	#performance


# top 10 agent performance   (mean num of solved problem of every agent per total problem taken )
select agent ,concat((sum(`Helped Resolve Surveys`)/ count('Case ID'))*100,'%') as performance
from survey
group by agent
order by  performance desc                                                        
limit 10;
-----------------------------------------------------------------------
           # lowest 10 agent performance
select agent ,concat((sum(`Helped Resolve Surveys`)/ count('Case ID'))*100,'%') as performance
from survey
group by agent
order by  performance asc
limit 10;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                                 # issuse frequent

 #  all issuse frequent
select `Consult Outcome`, count(`Chat Engaged`)
from aht
group by `Consult Outcome`


      # issuse frequent AND ITS AVG STAR RATE
SELECT a.`Consult Outcome`, COUNT(`Chat Engaged`) AS "issuse frequent",  AVG(`CSAT Star Average`) AS "AVG STAR RATE"
FROM aht as A
INNER JOIN survey as s ON A.`Case ID` = s.`Case ID`
GROUP BY A.`Consult Outcome`
ORDER BY COUNT(`Chat Engaged`) DESC;

-------------------------------------------
 #  issuse frequent per every month
SELECT MONTH(Date),
SUM(`1 Star Count`) AS "one_star_reviews",
SUM(`2 Star Count`) AS "two_star_reviews",
SUM(`3 Star Count`) AS "three_star_reviews",
SUM(`4 Star Count`) AS "four_star_reviews",
SUM('5 Star Count') AS "five_star_reviews"
FROM survey 
GROUP BY MONTH(Date)
ORDER BY SUM(`1 Star Count`) AND SUM(`2 Star Count`) DESC;


 -----------------------------------------------------------------------------------------------------------------------------------------------------------------
													    ----------------------------------------------
                                                                           # aht 

# avg (aht )per every a agent 
 SELECT h.ï»¿Agent, ROUND(AVG(AHT),2) AS "AHT" 
 FROM hire as h
 JOIN aht AS a ON h.ï»¿Agent = a.Agent
 GROUP BY h.ï»¿Agent
 ORDER BY ROUND(AVG(AHT),2) DESC LIMIT 10;
 
 --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
														----------------------------------------------
                                                                           #wrap min  
 # HIGHEST 10 AGENT Has HIGH WRAP TIME
SELECT h.ï»¿Agent,
round(AVG(`Total Wrap Minutes`),2) AS "HIGHEST 10 AGENT Has HIGH WRAP TIME "
FROM aht a 
JOIN hire h ON a.Agent =h.ï»¿Agent
GROUP BY h.ï»¿Agent
ORDER BY AVG(`Total Wrap Minutes`) DESC LIMIT 10;

---------------------------------------------------------------------------------------------------------------------------------------------------------------
											     		----------------------------------------------
                                                                        #worked minutes

# total work minutes for each agent
SELECT Agent, ROUND(SUM(`Total Work Minutes`)) AS "TOTAl WORK MINUTES"
FROM aht
GROUP BY Agent
ORDER BY ROUND(avg(`Total Work Minutes`)) DESC;

-----------------------------------------------------

# avg total work minutes for each agent
SELECT Agent, ROUND(avg(`Total Work Minutes`)) AS "avg of work min"
FROM aht
GROUP BY Agent
ORDER BY ROUND(avg(`Total Work Minutes`)) DESC;
-----------------------------------------------------

# avg  work time did every issue take 
SELECT `Consult Outcome`, ROUND(AVG(`Total Work Minutes`),2) as 'avg issue work time' 
FROM aht
GROUP BY `Consult Outcome`
ORDER BY ROUND(AVG(`Total Work Minutes`),2) DESC ;


----------------------------------------------------------------------------------------------------------------------------------------------------------
                                                          ----------------------------------------------
                                                                             #language 
# language sector with customer satisfication
SELECT Language, AVG(`CSAT Star Average`) 
FROM survey
GROUP BY Language
ORDER BY AVG(`CSAT Star Average`) DESC;
-----------------------------------------------------------------------------------------------------------------------------------------------------------
 
 
 









 
 
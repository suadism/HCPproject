
 
 -- Question 1 ---
with SUM AS
 (SELECT calls.Territory AS Territory , SUM(panel_list.Call_Goal) AS Total_call_goal, SUM(calls.Calls) AS Total_calls FROM panel_list, calls
WHERE calls.HCP_ID =  panel_list.HCP_ID AND panel_list.Territory = calls.Territory
GROUP BY  calls.Territory
)
SELECT Territory, Total_call_goal, Total_calls, (Total_calls/Total_call_goal) AS Call_goal_attainment
 FROM SUM
 ORDER BY Call_goal_attainment DESC
 
 -- Question 1(By Specialty) --
 
 with SUM AS
 (SELECT specialty.Specialty AS Specialty, SUM(panel_list.Call_Goal) AS Total_call_goal, SUM(calls.Calls) AS Total_calls FROM panel_list, calls, Specialty
WHERE calls.HCP_ID=panel_list.HCP_ID AND calls.HCP_ID=Specialty.HCP_ID AND panel_list.Territory = calls.Territory
GROUP BY  specialty.Specialty
)
SELECT Specialty, Total_call_goal, Total_calls, (Total_calls/Total_call_goal) AS Call_goal_attainment
 FROM SUM
 ORDER BY Call_goal_attainment DESC
 
-- Question 2---
-- % of calls that are off panel -- 
with c as (SELECT  SUM(Calls) as total_calls FROM calls),

d as (SELECT  SUM(calls.Calls) AS total_calls_offpanel 
FROM calls 
WHERE calls.HCP_ID  NOT IN (SELECT panel_list.HCP_ID from panel_list))

SELECT total_calls, total_calls_offpanel,(total_calls_offpanel/total_calls*100) as percent_offpanel_calls FROM c,d
-- any territories that stand out -- 

SELECT  SUM(calls.Calls) AS total_calls_offpanel ,Territory
FROM calls 
WHERE calls.HCP_ID  NOT IN (SELECT panel_list.HCP_ID from panel_list)
GROUP BY Territory
ORDER BY SUM(calls.Calls) DESC


-- Question 3 ---
SELECT  sum(calls.Calls) AS total_calls, specialty.Specialty FROM calls , specialty
WHERE calls.HCP_ID=specialty.HCP_ID
GROUP BY Specialty


SELECT  SUM(calls.Calls) AS total_calls, segment.Segment FROM calls , segment
WHERE calls.HCP_ID=segment.HCP_ID
GROUP BY Segment


-- Question 4--
-- Total HCPs on Panel --

SELECT COUNT(DISTINCT HCP_ID) FROM panel_list
-- Total HCPS on panel where consent is provided --
SELECT  COUNT(panel_list_2.HCP_ID) AS total_HCP_withconsent
FROM panel_list_2 , consent
WHERE panel_list_2.HCP_ID=consent.HCP_ID

-- consent rates by Territory --
with a AS 
(SELECT  panel_list_2.Territory AS Territory , COUNT(panel_list_2.HCP_ID) AS total_HCP_withconsent
FROM panel_list_2 , consent
WHERE panel_list_2.HCP_ID=consent.HCP_ID
GROUP BY Territory) ,

b AS
(SELECT Territory, COUNT(HCP_ID) AS total_HCP
FROM panel_list_2
GROUP BY Territory) 

SELECT a.Territory, total_HCP_withconsent,total_HCP, (total_HCP_withconsent/total_HCP*100) AS Consent_Rate
FROM a
JOIN b ON a.Territory=b.Territory

-- consent rates by segment --

with a AS 
(SELECT  COUNT(panel_list_2.HCP_ID) AS total_HCP_withconsent, segment.Segment
FROM panel_list_2 , consent, segment
WHERE panel_list_2.HCP_ID=consent.HCP_ID AND segment.HCP_ID=panel_list_2.HCP_ID
GROUP BY Segment) ,

b AS
(SELECT  segment, COUNT(panel_list_2.HCP_ID) AS total_HCP
FROM panel_list_2, segment
WHERE segment.HCP_ID=panel_list_2.HCP_ID
GROUP BY Segment) 

SELECT a.SEGMENT, total_HCP_withconsent,total_HCP, (total_HCP_withconsent/total_HCP*100) AS consent_rate
FROM a
JOIN b ON a.Segment=b.Segment

-- consent rate by specialty --
with a AS 
(SELECT  COUNT(panel_list_2.HCP_ID) AS total_HCP_withconsent, specialty.Specialty
FROM panel_list_2 , consent, specialty
WHERE panel_list_2.HCP_ID=consent.HCP_ID AND specialty.HCP_ID=panel_list_2.HCP_ID
GROUP BY Specialty),

b AS
(SELECT  Specialty, COUNT(panel_list_2.HCP_ID) AS total_HCP
FROM panel_list_2, specialty
WHERE specialty.HCP_ID=panel_list_2.HCP_ID
GROUP BY Specialty) 

SELECT a.Specialty, total_HCP_withconsent,total_HCP, (total_HCP_withconsent/total_HCP*100) AS consent_rate
FROM a
JOIN b ON a.Specialty=b.Specialty


-- Additional insight--
-- 1 total off panel HCPs with consent -- 

SELECT  COUNT(DISTINCT calls.HCP_ID) AS total_HCP_off panel_withconsent
FROM calls, consent
WHERE calls.HCP_ID NOT IN (SELECT panel_list.HCP_ID FROM panel_list) and calls.HCP_ID=consent.HCP_ID

-- 2 breakdown of calls by HCP cconsent status --
SELECT  SUM(calls.Calls) AS total_calls_withHCPs_withconsent
FROM calls,consent
WHERE calls.HCP_ID = consent.HCP_ID 
UNION 
Select SUM(calls.Calls) 
from calls
-- 3 breakdown of HCPs by segment --- 


with SUM AS
 (SELECT  SUM(calls.Calls) AS Total_calls FROM calls, panel_list
WHERE calls.HCP_ID = panel_list.HCP_ID 
 AND panel_list.Territory = calls.Territory
 group by calls.territory
)

 (SELECT  Territory, SUM(calls.Calls) AS Total_calls FROM calls

 group by calls.territory
)









	












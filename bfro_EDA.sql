

--SELECT * FROM bfro_reports_geocoded LIMIT 100

--count number of sightings per state and range of sighting dates--
--exclude class C reports - more effective to drop class C
Select bfro_reports_geocoded.state, count(*), 
min(bfro_reports_geocoded.date) as start, 
max(bfro_reports_geocoded.date) as final 
from bfro_reports_geocoded
WHERE bfro_reports_geocoded.classification = 'Class A'
OR bfro_reports_geocoded.classification = 'Class B'
group by bfro_reports_geocoded.state
order by start

--First query to see states and number
SELECT bfro_reports_geocoded.state AS StateofSighting, 
COUNT(*) AS SightingNumber
FROM bfro_reports_geocoded
GROUP BY StateofSighting
ORDER BY SightingNumber DESC

--updated to keep out class C
SELECT bfro_reports_geocoded.state AS StateofSighting, 
COUNT(*) AS SightingNumber
FROM bfro_reports_geocoded
WHERE bfro_reports_geocoded.classification != 'Class C'
GROUP BY StateofSighting
ORDER BY SightingNumber DESC

--same query as above, written more efficiently to ignore Class C values
Select bfro_reports_geocoded.state, count(*), 
min(bfro_reports_geocoded.date) as start, 
max(bfro_reports_geocoded.date) as final 
from bfro_reports_geocoded
WHERE bfro_reports_geocoded.classification != 'Class C'
group by bfro_reports_geocoded.state
order by start

--find outliers - earliest dates, states w few sightings

SELECT bfro_reports_geocoded.state, bfro_reports_geocoded.`date` as eventdate
FROM bfro_reports_geocoded
ORDER BY eventdate
LIMIT 10

SELECT bfro_reports_geocoded.state, bfro_reports_geocoded.`date` as eventdate
FROM bfro_reports_geocoded
WHERE bfro_reports_geocoded.state = 'California'
ORDER BY eventdate
LIMIT 10

--remove earliest date as it is ~50 years before the next closest sightings
DELETE from bfro_reports_geocoded
WHERE bfro_reports_geocoded.`date` = '1869-11-10'

--states w highest percentage of sightings
--First we calculate total # of sightings
Select count(bfro_reports_geocoded.number) FROM bfro_reports_geocoded
WHERE bfro_reports_geocoded.classification = 'Class A'
or bfro_reports_geocoded.classification = 'Class B'
--yields result 5,052
--Calculate percentages using total
SELECT bfro_reports_geocoded.state as STATE, count(bfro_reports_geocoded.state) as NumSightings,
(COUNT(bfro_reports_geocoded.state)/ 5052)*100 as Statepercent
from bfro_reports_geocoded
where bfro_reports_geocoded.classification = 'Class A'
or bfro_reports_geocoded.classification = 'Class B'
group by bfro_reports_geocoded.state
order by NumSightings DESC

--now lets see if we can see these percentages with the full table to help find outlier states

Select bfro_reports_geocoded.state as STATE,
count(bfro_reports_geocoded.state) as NumSightings, 
(COUNT(bfro_reports_geocoded.state)/ 5052)*100 as Statepercent,
min(bfro_reports_geocoded.date) as start, 
max(bfro_reports_geocoded.date) as final 
from bfro_reports_geocoded
where bfro_reports_geocoded.classification != 'Class C'
group by bfro_reports_geocoded.state
order by NumSightings DESC

--above using CTE
With sightingtotals AS (
    Select bfro_reports_geocoded.state as STATE, count(bfro_reports_geocoded.number) FROM bfro_reports_geocoded
    WHERE bfro_reports_geocoded.classification = 'Class A'
    or bfro_reports_geocoded.classification = 'Class B' 
)
Select bfro_reports_geocoded.state as STATE,
count(bfro_reports_geocoded.state) as NumSightings, 
min(bfro_reports_geocoded.date) as start, 
max(bfro_reports_geocoded.date) as final 
FROM bfro_reports_geocoded
LEFT JOIN sightingtotals 
ON bfro_reports_geocoded.state = sightingtotals.STATE
group by bfro_reports_geocoded.state
order by NumSightings DESC


--IQR done in excel from statepercent query, remove values under 27 as outliers

--Create a table with above data, including avg lat and longitude to be plotted later

Select bfro_reports_geocoded.state as STATE,
count(bfro_reports_geocoded.state) as NumSightings, 
(COUNT(bfro_reports_geocoded.state)/ 5052)*100 as Statepercent,
min(bfro_reports_geocoded.date) as start, 
max(bfro_reports_geocoded.date) as final,
avg(bfro_locations.latitude) as latavg,
avg(bfro_locations.longitude) as longavg
from bfro_reports_geocoded
LEFT JOIN bfro_locations on bfro_reports_geocoded.number = bfro_locations.number
where bfro_reports_geocoded.classification != 'Class C'
group by bfro_reports_geocoded.state
order by NumSightings DESC

--Let's now try to view by season
Select bfro_reports_geocoded.season as season,
count(bfro_reports_geocoded.number) as NumSightings,
(count(bfro_reports_geocoded.number)/5052)*100 as SeasonPercent
from bfro_reports_geocoded
where bfro_reports_geocoded.classification != 'Class C'
group by bfro_reports_geocoded.season
order by NumSightings Desc

--this shows that about 87 sightings occur in the 'unknown' let's get a better look at those
--query demonstrates that the 'unknown' season sightings occur at numbers below the IQR found in the previous 
--outlier inquiry
Select bfro_reports_geocoded.season as season,
bfro_reports_geocoded.state as state,
count(bfro_reports_geocoded.number) as sightings,
(COUNT(bfro_reports_geocoded.number)/ 5052)*100 as Statepercent
--bfro_reports_geocoded.observed as info
from bfro_reports_geocoded
where bfro_reports_geocoded.classification != 'Class C'
and bfro_reports_geocoded.season = 'Unknown'
group by season, state
order by Statepercent

--so, we can drop sightings in the 'unknown' season, and the states with under 27 sightings

--We also want to examine sightings by season, by state
Select bfro_reports_geocoded.season as season,
bfro_reports_geocoded.state as state,
count(bfro_reports_geocoded.number) as sightings,
(COUNT(bfro_reports_geocoded.number)/ 5052)*100 as Statepercent
--bfro_reports_geocoded.observed as info
from bfro_reports_geocoded
where bfro_reports_geocoded.classification != 'Class C'
and bfro_reports_geocoded.season = !'Unknown'
group by season, state
order by state, sightings desc

Select bfro_reports_geocoded.season as season,
bfro_reports_geocoded.state as state,
count(bfro_reports_geocoded.number) as sightings,
(COUNT(bfro_reports_geocoded.number)/ 5052)*100 as allpercent
--bfro_reports_geocoded.observed as info
from bfro_reports_geocoded
where bfro_reports_geocoded.classification != 'Class C'
and bfro_reports_geocoded.season != 'Unknown'
group by season, state
order by state


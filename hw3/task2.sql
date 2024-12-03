SELECT * FROM dbo.tblEvent te
WHERE te.CountryID = 21
ORDER BY EventDate DESC;
  

SELECT MAX(EventDate) FROM dbo.tblEvent te
WHERE te.CountryID = 21;

SELECT * FROM dbo.tblEvent 
WHERE EventDate > (SELECT MAX(EventDate) FROM dbo.tblEvent te
WHERE te.CountryID = 21);




SELECT 
    EventName, 
    EventDate, 
    CountryID
FROM 
    tblEvent
WHERE 
    EventDate > (
        SELECT 
            MAX(EventDate)
        FROM 
            tblEvent
        WHERE 
            CountryId = 21
    )
ORDER BY 
    EventDate DESC;
   
   
   
-- To display the query result formatted similarly to the image  
SELECT en.EventName, en.EventDate, c.CountryName FROM dbo.tblCountry c
JOIN (SELECT 
    EventName, 
    EventDate, 
    CountryID
FROM 
    tblEvent
WHERE 
    EventDate > (
        SELECT 
            MAX(EventDate)
        FROM 
            tblEvent
        WHERE 
            CountryId = 21
    )
) AS en ON c.CountryID = en.CountryID
ORDER BY EventDate DESC;







SELECT * FROM dbo.tblCountry;


SELECT CountryID , COUNT(CountryID) AS NumberOfEvents FROM dbo.tblEvent te
GROUP BY CountryID;

SELECT * FROM (SELECT CountryID , COUNT(CountryID) AS NumberOfEvents FROM dbo.tblEvent te
GROUP BY CountryID) AS counter
WHERE NumberOfEvents > 8
AND (SELECT * FROM dbo.tblCountry c WHERE c.CountryID = counter.CountryID);





SELECT 
    CountryName
FROM 
    tblCountry c
WHERE 
    (SELECT COUNT(*) 
     FROM tblEvent e 
     WHERE e.CountryId = c.CountryId) > 8
ORDER BY 
    CountryName ASC;

   
  SELECT 
    CountryName
FROM 
    tblCountry c
WHERE 
    (SELECT COUNT(*) 
     FROM tblEvent e 
     WHERE e.CountryId = c.CountryId) > 8
ORDER BY 
    CountryName ASC; 
   
   
 
   
-- Create a CTE (called ThisAndThat?) to determine the values of the IfThis and IfThat flags for each event.
WITH ThisAndThat AS (
    SELECT
    	EventName,
    	EventDetails,
        EventId, -- Keep track of each event
        CASE 
            WHEN EventDetails LIKE '%this%' THEN 1 
            ELSE 0 
        END AS IfThis, -- Set IfThis flag
        CASE 
            WHEN EventDetails LIKE '%that%' THEN 1 
            ELSE 0 
        END AS IfThat  -- Set IfThat flag
    FROM 
        tblEvent
)

-- Use this CTE to get the required results, as shown at the start of this exercise.
SELECT 
    IfThis, 
    IfThat, 
    COUNT(*) AS NumberOfEvents -- Count the events for each combination
FROM 
    ThisAndThat
GROUP BY 
    IfThis, 
    IfThat
ORDER BY 
    NumberOfEvents DESC;

   
   

WITH EventDetails AS (
  SELECT
    EventName,
    EventDetails,
    CASE
      WHEN EventDetails LIKE '%this%' THEN 1
      ELSE 0
    END AS HasThis,
    CASE
      WHEN EventDetails LIKE '%that%' THEN 1
      ELSE 0
    END AS HasThat
  FROM tblEvent
)





-- Create a CTE (called ThisAndThat?) to determine the values of the IfThis and IfThat flags for each event.
WITH ThisAndThat AS (
    SELECT
    	EventName,
    	EventDetails,
        EventId, -- Keep track of each event
        CASE 
            WHEN EventDetails LIKE '%this%' THEN 1 
            ELSE 0 
        END AS IfThis, -- Set IfThis flag
        CASE 
            WHEN EventDetails LIKE '%that%' THEN 1 
            ELSE 0 
        END AS IfThat  -- Set IfThat flag
    FROM 
        tblEvent
)

-- Use this CTE to get the required results, as shown at the start of this exercise.
SELECT EventName, EventDetails
FROM ThisAndThat
WHERE IfThis = 1 AND IfThat = 1;


SELECT 
    ContinentID
FROM 
    tblCountry
GROUP BY 
    ContinentId
HAVING 
    COUNT(CountryId) >= 3
    
    
SELECT 
    ContinentId
FROM 
    tblEvent e
INNER JOIN 
    tblCountry c ON e.CountryId = c.CountryId
GROUP BY 
    ContinentId
HAVING 
    COUNT(EventId) <= 10


    
    
WITH ManyCountries AS (
    SELECT 
        ContinentId
    FROM 
        tblCountry
    GROUP BY 
        ContinentId
    HAVING 
        COUNT(CountryId) >= 3 -- At least 3 countries
), 
FewEvents AS (
    SELECT 
        c.ContinentId,
        COUNT(e.EventID) AS NumberOfEvents
    FROM 
        tblEvent e
    INNER JOIN 
        tblCountry c ON e.CountryId = c.CountryId
    GROUP BY 
        c.ContinentId
    HAVING 
        COUNT(e.EventId) <= 10 -- At most 10 events
)

SELECT 
    c.CountryName, 
    fe.NumberOfEvents
FROM 
    ManyCountries mc
JOIN 
    FewEvents fe ON mc.ContinentID = fe.ContinentID
JOIN 
    tblCountry c ON fe.ContinentID = c.ContinentID;


    SELECT 
        ContinentId
    FROM 
        tblCountry
    GROUP BY 
        ContinentId

--SELECT * FROM FewEvents;
--SELECT * FROM ManyCountries;
-- Step 2: Combine Results
SELECT 
    c.ContinentId,
    ContinentName,
    COUNT(DISTINCT c.CountryId) AS TotalCountries,
    COUNT(e.EventId) AS TotalEvents
FROM 
    ManyCountries mc
INNER JOIN 
    FewEvents fe ON mc.ContinentId = fe.ContinentId
INNER JOIN 
    tblContinent c ON c.ContinentId = mc.ContinentId
LEFT JOIN 
    tblEvent e ON e.CountryId = c.CountryId
GROUP BY 
    c.ContinentId, ContinentName
ORDER BY 
    ContinentName;


   
WITH EVENTSBYERA AS (
SELECT
	CASE
		WHEN YEAR(e.EventDate) < 1900 THEN '19th century and earlier'
		WHEN YEAR(e.EventDate) < 2000 THEN '20th century'
		ELSE '21st century'
	END AS Era,
		e.EventID
FROM
	tblEvent AS e
)


SELECT 
	e.Era,
	COUNT(*) AS 'NUMBER OF EVENTS'
FROM 
	EVENTSBYERA AS e
GROUP BY 
	e.Era;

SELECT * FROM 



   

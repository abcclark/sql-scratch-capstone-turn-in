SELECT DISTINCT utm_campaign AS 'Campaign' 
FROM page_visits
ORDER BY 1 ASC;


SELECT DISTINCT utm_source AS 'Source'
FROM page_visits
ORDER BY 1 ASC;


SELECT utm_campaign AS 'Campaign',
       utm_source AS 'Source'
FROM page_visits
GROUP BY 1, 2
ORDER BY 2;


SELECT DISTINCT page_name AS 'Page Name'
FROM page_visits;


WITH first_touch AS
       (SELECT user_id, 
               min(timestamp) AS first_time
        FROM page_visits
        GROUP BY user_id)
,attribution AS
        (SELECT ft.user_id, ft.first_time, 	     
                pv.utm_campaign, 
         	    pv.utm_source
         FROM first_touch ft
         JOIN page_visits pv
              ON ft.user_id = pv.user_id
              AND ft.first_time = pv.timestamp)
SELECT COUNT(*) as 'Total First Touches',
      attribution.utm_campaign AS 'Campaign',
      attribution.utm_source AS 'Source'
FROM attribution
GROUP BY 2, 3
ORDER BY 1 DESC;


with last_touch AS
     (SELECT user_id,
             MAX(timestamp) AS last_time
     FROM page_visits
     GROUP BY user_id)
,attribution AS 
     (SELECT lt.user_id,
	     lt.last_time,
             pv.utm_campaign,
             pv.utm_source,
       	     pv.page_name
      FROM last_touch lt
      JOIN page_visits pv
        ON lt.user_id = pv.user_id
        AND lt.last_time = pv.timestamp)
SELECT COUNT(*) AS 'Total Last Touches',
	     attribution.utm_campaign AS 'campaign',
	     attribution.utm_source AS 'source'
FROM attribution
GROUP BY 2, 3
ORDER BY 1 DESC;


SELECT COUNT(Distinct user_id) AS 'Total Distinct Users', 
       page_name AS 'Page Name'
FROM page_visits
GROUP BY 2;


with last_touch AS
	(SELECT user_id,
  	        max(timestamp) AS last_time
         FROM page_visits
         WHERE page_name = '4 - purchase'
         GROUP BY user_id)
 ,attribution AS 
	(SELECT lt.user_id,
  	        lt.last_time,
                pv.utm_campaign,
                pv.utm_source
         FROM last_touch lt
         JOIN page_visits pv
	     ON lt.user_id = pv.user_id
             AND lt.last_time = pv.timestamp)
SELECT COUNT(attribution.last_time) AS 'Total',
       attribution.utm_campaign AS 'Campaign',
       attribution.utm_source AS 'Source'
FROM attribution
GROUP BY 2
ORDER BY 1 DESC;

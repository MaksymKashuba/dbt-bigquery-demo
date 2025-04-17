WITH city_capacity_cte AS (
    SELECT city,
           AVG(capacity) AS avg_capacity
    FROM {{ ref('stadium_cleaned') }}
    WHERE capacity > 40000
    GROUP BY city
),
filtered_stadiums_cte AS (
    SELECT s.name,
           s.city,
           s.capacity,
           s.country
    FROM {{ ref('stadium_cleaned') }} s
    JOIN city_capacity_cte c
    ON s.city = c.city
),
stadium_cte AS (
    SELECT name,
           city,
           capacity,
           country,
           events_hosted
    FROM filtered_stadiums_cte
    WHERE capacity > 30000
),
enhanced_stadium_cte AS (
    SELECT name,
           city,
           capacity,
           country,
           events_hosted,
           (events_hosted / NULLIF(capacity, 0)) * 100 AS utilization_percentage
    FROM stadium_cte
    WHERE (events_hosted / NULLIF(capacity, 0)) * 100 > 50
)
SELECT name,
       city,
       capacity,
       country,
       events_hosted,
       utilization_percentage
FROM enhanced_stadium_cte
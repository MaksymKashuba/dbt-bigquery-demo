WITH city_capacity AS (
    SELECT city
    FROM {{ ref('stadium_cleaned') }}
    WHERE capacity > 40000
    GROUP BY city
)
SELECT 
    s.stadium,
    s.city,
    s.capacity,
    s.country,
    s.region,
    s.rank,
    s.images,
    s.home_team,
    s.location
FROM {{ ref('stadium_cleaned') }} s
JOIN city_capacity c ON s.city = c.city
WHERE s.capacity > 30000
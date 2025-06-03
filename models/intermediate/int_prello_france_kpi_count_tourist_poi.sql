SELECT
    municipality_code,
    COUNT(*) AS count_tourist_poi
FROM {{ ref('stg_prello_france__POI_tourist_establishments') }}
WHERE municipality_code IS NOT NULL
GROUP BY municipality_code
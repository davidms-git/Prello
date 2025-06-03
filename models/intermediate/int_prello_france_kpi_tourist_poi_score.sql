SELECT
    municipality_code,
    ROUND(SUM(importance), 2) AS tourist_poi_score
FROM {{ ref('stg_prello_france__POI_tourist_establishments') }}
WHERE importance IS NOT NULL AND importance > 0
  AND municipality_code IS NOT NULL
GROUP BY municipality_code
WITH base_counts AS (
    SELECT
        municipality_code,
        COUNT(*) AS count_tourist_poi
    FROM {{ ref('stg_prello_france__POI_tourist_establishments') }}
    WHERE municipality_code IS NOT NULL
    GROUP BY municipality_code
),

stats AS (
    SELECT
        MIN(count_tourist_poi) AS min_count,
        MAX(count_tourist_poi) AS max_count
    FROM base_counts
)

SELECT
    b.municipality_code,
    b.count_tourist_poi,
    ROUND(
        CASE 
            WHEN s.max_count != s.min_count THEN 
                (b.count_tourist_poi - s.min_count) / (s.max_count - s.min_count)
            ELSE 0
        END,
        2
    ) AS count_tourist_poi_normalized
FROM base_counts b
CROSS JOIN stats s

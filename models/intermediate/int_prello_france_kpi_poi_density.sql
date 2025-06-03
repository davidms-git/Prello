WITH poi_counts AS (
    SELECT
        municipality_code,
        COUNT(*) AS poi_count
    FROM {{ ref('stg_prello_france__POI_touristic_sites_by_municipality') }}
    GROUP BY municipality_code
),

latest_population AS (
    SELECT
        municipality_code,
        population
    FROM {{ ref('stg_prello_france__population_by_municipality') }}
    WHERE year = (
        SELECT MAX(year) FROM {{ ref('stg_prello_france__population_by_municipality') }}
    )
)

SELECT
    poi_counts.municipality_code,
    poi_count,
    population,
    ROUND(SAFE_DIVIDE(poi_count, population), 2) AS poi_density
FROM poi_counts
JOIN latest_population
    ON poi_counts.municipality_code = latest_population.municipality_code
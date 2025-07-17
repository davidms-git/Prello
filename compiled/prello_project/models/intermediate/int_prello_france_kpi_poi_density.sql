WITH poi_counts AS (
    SELECT
        municipality_code,
        COUNT(*) AS poi_count
    FROM `prello-france`.`dbt_ddelmor`.`stg_prello_france__POI_touristic_sites_by_municipality`
    GROUP BY municipality_code
),

latest_population AS (
    SELECT
        municipality_code,
        population
    FROM `prello-france`.`dbt_ddelmor`.`stg_prello_france__population_by_municipality`
    WHERE year = (
        SELECT MAX(year) FROM `prello-france`.`dbt_ddelmor`.`stg_prello_france__population_by_municipality`
    )
),

joined_data AS (
    SELECT
        pc.municipality_code,
        poi_count,
        population,
        SAFE_DIVIDE(poi_count, population) AS poi_density
    FROM poi_counts pc
    JOIN latest_population lp
        ON pc.municipality_code = lp.municipality_code
),

stats AS (
    SELECT
        MIN(poi_density) AS min_density,
        MAX(poi_density) AS max_density,
        MIN(poi_count) AS min_count,
        MAX(poi_count) AS max_count
    FROM joined_data
)

SELECT
    jd.municipality_code,
    jd.poi_count,
    jd.population,
    ROUND(jd.poi_density, 2) AS poi_density,
    
    ROUND(
        CASE 
            WHEN s.max_density != s.min_density THEN
                (jd.poi_density - s.min_density) / (s.max_density - s.min_density)
            ELSE 0
        END,
        2
    ) AS poi_density_normalized,

    ROUND(
        CASE
            WHEN s.max_count != s.min_count THEN
                (jd.poi_count - s.min_count) / (s.max_count - s.min_count)
            ELSE 0
        END,
        2
    ) AS poi_count_normalized

FROM joined_data jd
CROSS JOIN stats s
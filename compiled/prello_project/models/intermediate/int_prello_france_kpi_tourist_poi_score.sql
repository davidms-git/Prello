WITH base AS (
    SELECT
        municipality_code,
        SUM(importance) AS raw_establishment_score
    FROM `prello-france`.`dbt_ddelmor`.`stg_prello_france__POI_tourist_establishments`
    WHERE importance IS NOT NULL
      AND municipality_code IS NOT NULL
    GROUP BY municipality_code
),

max_score AS (
    SELECT MAX(raw_establishment_score) AS max_score
    FROM base
),

normalized AS (
    SELECT
        b.municipality_code,
        b.raw_establishment_score,
        ROUND(SAFE_DIVIDE(b.raw_establishment_score, m.max_score), 4) AS establishment_score_normalized
    FROM base b
    CROSS JOIN max_score m
)

SELECT *
FROM normalized
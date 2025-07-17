

  create or replace view `prello-france`.`dbt_ddelmor`.`int_prello_france_kpi_second_home_ratio_2`
  OPTIONS()
  as WITH ranked AS (
    SELECT
        municipality_code,
        year,
        nb_second_home,
        nb_tot_housing,
        ROW_NUMBER() OVER (
            PARTITION BY municipality_code
            ORDER BY year DESC
        ) AS rn
    FROM `prello-france`.`dbt_ddelmor`.`stg_prello_france__housing_stock_clean`
),

 base AS (SELECT
    municipality_code,
    year                                     AS latest_year,
    SUM(nb_second_home) AS nb_second_home,
    SUM(nb_tot_housing) AS nb_tot_housing,
    CASE
        WHEN SUM(nb_tot_housing) = 0 THEN NULL
        ELSE ROUND(SUM(nb_second_home) * 1.0 / SUM(nb_tot_housing), 2)
    END AS second_home_ratio
FROM ranked
WHERE rn = 1                                 -- keep only the latest-year row
GROUP BY municipality_code, year)

-- extra CTE to hold the min & max of the ratio
, stats AS (
    SELECT
        MIN(second_home_ratio) AS ratio_min,
        MAX(second_home_ratio) AS ratio_max
    FROM base 
)

SELECT
    b.*,
    -- min-max normalised ratio (0–1)
    (b.second_home_ratio - s.ratio_min)
      / NULLIF(s.ratio_max - s.ratio_min, 0)  AS second_home_ratio_normalized
FROM base AS b
CROSS JOIN stats AS s;


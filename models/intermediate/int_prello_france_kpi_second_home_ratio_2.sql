WITH ranked AS (
    SELECT
        municipality_code,
        year,
        nb_second_home,
        nb_tot_housing,
        ROW_NUMBER() OVER (
            PARTITION BY municipality_code
            ORDER BY year DESC
        ) AS rn
    FROM {{ ref('stg_prello_france__housing_stock_clean') }}
)

SELECT
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
GROUP BY municipality_code, year
WITH rental_data AS (
    SELECT
        municipality_code,
        rental_med_all
    FROM {{ ref('stg_prello_france__real_estate_info_by_municipality') }}
    WHERE rental_med_all IS NOT NULL
),

sales_data_2021 AS (
    SELECT
        municipality_code,
        sales_price_m2
    FROM {{ ref('stg_prello_france__notary_real_estate_sales_clean') }}
    WHERE sales_price_m2 IS NOT NULL
      AND municipality_code IS NOT NULL
      AND year = 2021
),

median_sales_price AS (
    SELECT
        municipality_code,
        APPROX_QUANTILES(sales_price_m2, 2)[OFFSET(1)] AS median_sales_price_m2_2021
    FROM sales_data_2021
    GROUP BY municipality_code
),

joined AS (
    SELECT
        rental_data.municipality_code,
        rental_med_all,
        median_sales_price_m2_2021,
        ROUND(SAFE_DIVIDE(rental_med_all, median_sales_price_m2_2021) * 100, 2) AS rental_yield_pct
    FROM rental_data
    JOIN median_sales_price
        ON rental_data.municipality_code = median_sales_price.municipality_code
)

SELECT *
FROM joined
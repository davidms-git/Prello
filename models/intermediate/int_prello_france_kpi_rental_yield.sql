WITH rental_data AS (
    SELECT
        municipality_code,
        rental_med_all
    FROM {{ ref('stg_prello_france__real_estate_info_by_municipality') }}
    WHERE rental_med_all IS NOT NULL
),

sales_data AS (
    SELECT
        municipality_code,
        AVG(sales_price_m2) AS avg_sales_price_m2
    FROM {{ ref('stg_prello_france__notary_real_estate_sales_clean') }}
    WHERE sales_price_m2 IS NOT NULL
      AND municipality_code IS NOT NULL
    GROUP BY municipality_code
),

joined AS (
    SELECT
        rental_data.municipality_code,
        rental_med_all,
        avg_sales_price_m2,
        ROUND(SAFE_DIVIDE(rental_med_all, avg_sales_price_m2), 4) AS rental_yield
    FROM rental_data
    JOIN sales_data
        ON rental_data.municipality_code = sales_data.municipality_code
)

SELECT *
FROM joined
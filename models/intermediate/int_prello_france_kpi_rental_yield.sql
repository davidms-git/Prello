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
        ROUND(SAFE_DIVIDE(rental_med_all * 12, median_sales_price_m2_2021), 4) AS rental_yield_yearly
    FROM rental_data
    JOIN median_sales_price
        ON rental_data.municipality_code = median_sales_price.municipality_code
),

stats AS (
    SELECT 
        MAX(rental_yield_yearly) AS max_rental_yield,
        MIN(rental_yield_yearly) AS min_rental_yield
        FROM joined
),

normalized AS (
    SELECT
        j.*,
        ROUND(SAFE_DIVIDE(j.rental_yield_yearly - s.min_rental_yield, s.max_rental_yield - s.min_rental_yield), 4) AS rental_yield_normalized
    FROM joined j
    CROSS JOIN stats s
)


SELECT *
FROM normalized
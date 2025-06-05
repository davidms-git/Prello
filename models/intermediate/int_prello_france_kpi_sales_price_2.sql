WITH base AS (

    -- raw input (no changes)
    SELECT
        municipality_code,
        year,
        sales_price_m2
    FROM {{ ref('stg_prello_france__notary_real_estate_sales_clean') }}

), last_year_flag AS (

    -- find the most recent year per municipality
    SELECT
        *,
        MAX(year) OVER (PARTITION BY municipality_code) AS latest_year_for_muni
    FROM base

), filtered AS (

    -- keep only rows that belong to that latest year
    SELECT *
    FROM last_year_flag
    WHERE year = latest_year_for_muni

), agg AS (

    -- aggregate within that single most-recent year (in case there are many rows)
    SELECT
        municipality_code,
        year                                    AS latest_year,
        AVG(sales_price_m2)                    AS avg_sales_price_m2
        -- add more metrics if useful, e.g. COUNT(*) AS n_transactions
    FROM filtered
    GROUP BY municipality_code, year

),

min_max AS (
    SELECT
        MIN(avg_sales_price_m2) AS min_val,
        MAX(avg_sales_price_m2) AS max_val
    FROM agg
)

SELECT
    a.municipality_code,
    a.latest_year,
    a.avg_sales_price_m2,
    (a.avg_sales_price_m2 - m.min_val) / NULLIF(m.max_val - m.min_val, 0) AS avg_sales_price_m2_normalized
FROM agg a
CROSS JOIN min_max m
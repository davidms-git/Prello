SELECT
  year_municipality_key,
  sales_price_m2
FROM {{ ref('stg_prello_france__notary_real_estate_sales_clean') }}
SELECT
  year_municipality_key,
  nb_second_home,
  nb_tot_housing,
  CASE 
    WHEN nb_tot_housing = 0 THEN NULL
    ELSE nb_second_home / nb_tot_housing
  END AS second_home_ratio
FROM {{ ref('stg_prello_france__housing_stock_clean') }}
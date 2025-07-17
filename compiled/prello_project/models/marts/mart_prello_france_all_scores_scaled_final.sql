

WITH base AS (
  SELECT *
  FROM `prello-france`.`dbt_ddelmor`.`mart_prello_france_joined_kpis_city_normalized_final_version`
),

scored AS (
  SELECT
    *,
    -- Raw scores (before normalisation)
    (
      rental_yield_clean_normalized * 0.15 +
      establishment_score * 0.25 +
      poi_density_clean * 0.25 +
      avg_growth_last_5_years * 0.05 +
      housing_stress_index_normalized * 0.10 +
      vacancy_rate_normalized * 0.05 +
      second_home_ratio * 0.10 +
      avg_sales_price_m2_latest * 0.05
    ) AS raw_vacation_seeker_score,

    (
      rental_yield_clean_normalized * 0.30 +
      establishment_score * 0.05 +
      poi_density_clean * 0.05 +
      avg_growth_last_5_years * 0.15 +
      housing_stress_index_normalized * 0.20 +
      vacancy_rate_normalized * 0.15 +
      second_home_ratio * 0.05 +
      avg_sales_price_m2_latest * 0.05
    ) AS raw_yield_investor_score,

    (
      rental_yield_clean_normalized * 0.05 +
      establishment_score * 0.20 +
      poi_density_clean * 0.10 +
      avg_growth_last_5_years * 0.10 +
      housing_stress_index_normalized * 0.05 +
      vacancy_rate_normalized * 0.05 +
      second_home_ratio * 0.15 +
      avg_sales_price_m2_latest * 0.30
    ) AS raw_luxury_buyer_score,

    (
      rental_yield_clean_normalized * ((0.15 + 0.30 + 0.05) / 3) +
      establishment_score * ((0.25 + 0.05 + 0.20) / 3) +
      poi_density_clean * ((0.25 + 0.05 + 0.10) / 3) +
      avg_growth_last_5_years * ((0.05 + 0.15 + 0.10) / 3) +
      housing_stress_index_normalized * ((0.10 + 0.20 + 0.05) / 3) +
      vacancy_rate_normalized * ((0.05 + 0.15 + 0.05) / 3) +
      second_home_ratio * ((0.10 + 0.05 + 0.15) / 3) +
      avg_sales_price_m2_latest * ((0.05 + 0.05 + 0.30) / 3)
    ) AS raw_city_opportunity_score
  FROM base
),

stats AS (
  SELECT
    MIN(raw_vacation_seeker_score) AS min_vac,
    MAX(raw_vacation_seeker_score) AS max_vac,
    MIN(raw_yield_investor_score) AS min_yield,
    MAX(raw_yield_investor_score) AS max_yield,
    MIN(raw_luxury_buyer_score) AS min_lux,
    MAX(raw_luxury_buyer_score) AS max_lux,
    MIN(raw_city_opportunity_score) AS min_city,
    MAX(raw_city_opportunity_score) AS max_city
  FROM scored
),

final AS (
  SELECT 
    s.municipality_code,
    s.city_name_normalized,
    s.latitude,
    s.longitude,

    -- Normalised 0-100 scores
    SAFE_DIVIDE(s.raw_vacation_seeker_score - st.min_vac, st.max_vac - st.min_vac) * 100 AS vacation_seeker_score,
    SAFE_DIVIDE(s.raw_yield_investor_score - st.min_yield, st.max_yield - st.min_yield) * 100 AS yield_investor_score,
    SAFE_DIVIDE(s.raw_luxury_buyer_score - st.min_lux, st.max_lux - st.min_lux) * 100 AS luxury_buyer_score,
    SAFE_DIVIDE(s.raw_city_opportunity_score - st.min_city, st.max_city - st.min_city) * 100 AS city_opportunity_score

  FROM scored s
  CROSS JOIN stats st
)

SELECT * FROM final
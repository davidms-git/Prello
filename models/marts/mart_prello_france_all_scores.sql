WITH base AS (
  SELECT *
  FROM {{ ref('mart_prello_france_joined_kpis_city_scoring_normalized_david') }}
),
scored AS (
  SELECT
    *,
    -- Vacation Seeker Score
    (
      rental_yield_normalized * 0.15 +
      establishment_score_normalized * 0.25 +
      poi_density_normalized * 0.25 +
      avg_growth_last_5_years_normalized * 0.05 +
      housing_stress_index_normalized * 0.10 +
      vacancy_rate_normalized * 0.05 +
      second_home_ratio_normalized * 0.10 +
      avg_sales_price_m2_normalized * 0.05
    ) AS vacation_seeker_score,
    -- Yield-Driven Investor Score
    (
      rental_yield_normalized * 0.30 +
      establishment_score_normalized * 0.05 +
      poi_density_normalized * 0.05 +
      avg_growth_last_5_years_normalized * 0.15 +
      housing_stress_index_normalized * 0.20 +
      vacancy_rate_normalized * 0.15 +
      second_home_ratio_normalized * 0.05 +
      avg_sales_price_m2_normalized * 0.05
    ) AS yield_investor_score,
    -- Luxury Buyer Score
    (
      rental_yield_normalized * 0.05 +
      establishment_score_normalized * 0.20 +
      poi_density_normalized * 0.10 +
      avg_growth_last_5_years_normalized * 0.10 +
      housing_stress_index_normalized * 0.05 +
      vacancy_rate_normalized * 0.05 +
      second_home_ratio_normalized * 0.15 +
      avg_sales_price_m2_normalized * 0.30
    ) AS luxury_buyer_score,
    -- Middle Management Score (baseline): average of all three persona weights
    (
      rental_yield_normalized * ((0.15 + 0.30 + 0.05) / 3) +
      establishment_score_normalized * ((0.25 + 0.05 + 0.20) / 3) +
      poi_density_normalized * ((0.25 + 0.05 + 0.10) / 3) +
      avg_growth_last_5_years_normalized * ((0.05 + 0.15 + 0.10) / 3) +
      housing_stress_index_normalized * ((0.10 + 0.20 + 0.05) / 3) +
      vacancy_rate_normalized * ((0.05 + 0.15 + 0.05) / 3) +
      second_home_ratio_normalized * ((0.10 + 0.05 + 0.15) / 3) +
      avg_sales_price_m2_normalized * ((0.05 + 0.05 + 0.30) / 3)
    ) AS city_opportunity_score
  FROM base
)
SELECT 
    municipality_code,
    city_name_normalized,
    latitude,
    longitude,
    city_opportunity_score,
    vacation_seeker_score,
    yield_investor_score,
    luxury_buyer_score
FROM scored
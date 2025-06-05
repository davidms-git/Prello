with city_scoring_kpis as (

    select * 
    from {{ ref('mart_prello_france_joined_kpis_city_scoring') }}

),

cleaned as (

    select
        * except(rental_yield_normalized, establishment_score_normalized, count_tourist_poi_normalized, poi_density_normalized, poi_count_normalized),
        coalesce(rental_yield_normalized, 0) as rental_yield_normalized,
        coalesce(establishment_score_normalized, 0) as establishment_score_normalized,
        coalesce(count_tourist_poi_normalized, 0) as count_tourist_poi_normalized,
        coalesce(poi_density_normalized, 0) as poi_density_normalized,
        coalesce(poi_count_normalized, 0) as poi_count_normalized
    from city_scoring_kpis
    where avg_sales_price_m2_normalized is not null
        and housing_stress_index_normalized is not null
        and vacancy_rate_normalized is not null
        and second_home_ratio_normalized is not null
        and avg_growth_last_5_years_normalized is not null

)

select 
    municipality_code,
    city_name_normalized,
    latitude,
    longitude,
    rental_yield_normalized, 
    avg_growth_last_5_years_normalized,
    housing_stress_index_normalized,
    vacancy_rate_normalized,
    second_home_ratio_normalized,
    avg_sales_price_m2_normalized,
    establishment_score_normalized, 
    count_tourist_poi_normalized, 
    poi_density_normalized, 
    poi_count_normalized
    
from cleaned
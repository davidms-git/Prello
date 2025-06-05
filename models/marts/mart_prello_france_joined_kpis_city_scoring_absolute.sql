with city_scoring_kpis as (

    select * 
    from {{ ref('mart_prello_france_joined_kpis_city_scoring') }}

),

cleaned as (

    select
        * except(rental_yield_yearly, raw_establishment_score, count_tourist_poi, poi_density, touristic_sites_poi_count),
        coalesce(rental_yield_yearly, 0) as rental_yield_clean,
        coalesce(raw_establishment_score, 0) as establishment_score_clean,
        coalesce(count_tourist_poi, 0) as count_tourist_poi_clean,
        coalesce(poi_density, 0) as poi_density_clean,
        coalesce(touristic_sites_poi_count, 0) as touristic_sites_poi_count_clean
    from city_scoring_kpis
    where avg_sales_price_m2_latest is not null
        and intensite_tension_immo is not null
        and vacancy_rate_normalized is not null
        and second_home_ratio is not null
        and avg_growth_last_5_years is not null

)

select * from cleaned


  create or replace view `prello-france`.`dbt_ddelmor`.`mart_prello_france_joined_kpis_city_normalized_final_version`
  OPTIONS()
  as with city_scoring_kpis as (

    select * 
    from `prello-france`.`dbt_ddelmor`.`mart_prello_france_joined_kpis_city_scoring`

),

cleaned as (

    select
        municipality_code,
        city_name_normalized,
        latitude,
        longitude,
        avg_sales_price_m2_latest,
        intensite_tension_immo as housing_stress_index_normalized,
        second_home_ratio,
        vacancy_rate_normalized,
        coalesce(rental_yield_yearly, 0) as rental_yield_clean,
        coalesce(raw_establishment_score, 0) as establishment_score,
        coalesce(count_tourist_poi, 0) as count_tourist_poi_clean,
        coalesce(poi_density, 0) as poi_density_clean,
        coalesce(touristic_sites_poi_count, 0) as touristic_sites_poi_count,
        avg_growth_last_5_years
    from city_scoring_kpis
    where avg_sales_price_m2_latest is not null
      and intensite_tension_immo is not null
      and vacancy_rate_normalized is not null
      and second_home_ratio is not null
      and avg_growth_last_5_years is not null

),

stats as (

    select
        min(avg_sales_price_m2_latest) as min_price,
        max(avg_sales_price_m2_latest) as max_price,

        min(housing_stress_index_normalized) as min_stress,
        max(housing_stress_index_normalized) as max_stress,

        min(second_home_ratio) as min_second_home,
        max(second_home_ratio) as max_second_home,

        min(vacancy_rate_normalized) as min_vacancy,
        max(vacancy_rate_normalized) as max_vacancy,

        min(rental_yield_clean) as min_rental_yield,
        max(rental_yield_clean) as max_rental_yield,

        min(establishment_score) as min_estab,
        max(establishment_score) as max_estab,

        min(count_tourist_poi_clean) as min_tourist_poi,
        max(count_tourist_poi_clean) as max_tourist_poi,

        min(poi_density_clean) as min_poi_density,
        max(poi_density_clean) as max_poi_density,

        min(touristic_sites_poi_count) as min_sites,
        max(touristic_sites_poi_count) as max_sites,

        min(avg_growth_last_5_years) as min_growth,
        max(avg_growth_last_5_years) as max_growth
    from cleaned

),

normalized as (

    select
        c.municipality_code,
        c.city_name_normalized,
        c.latitude,
        c.longitude,

        round((c.avg_sales_price_m2_latest - s.min_price) / nullif(s.max_price - s.min_price, 0), 2) as avg_sales_price_m2_latest,
        round((c.housing_stress_index_normalized - s.min_stress) / nullif(s.max_stress - s.min_stress, 0), 2) as housing_stress_index_normalized,
        round((c.second_home_ratio - s.min_second_home) / nullif(s.max_second_home - s.min_second_home, 0), 2) as second_home_ratio,
        round((c.vacancy_rate_normalized - s.min_vacancy) / nullif(s.max_vacancy - s.min_vacancy, 0), 2) as vacancy_rate_normalized,
        round((c.rental_yield_clean - s.min_rental_yield) / nullif(s.max_rental_yield - s.min_rental_yield, 0), 2) as rental_yield_clean_normalized,
        round((c.establishment_score - s.min_estab) / nullif(s.max_estab - s.min_estab, 0), 2) as establishment_score,
        round((c.count_tourist_poi_clean - s.min_tourist_poi) / nullif(s.max_tourist_poi - s.min_tourist_poi, 0), 2) as count_tourist_poi_clean,
        round((c.poi_density_clean - s.min_poi_density) / nullif(s.max_poi_density - s.min_poi_density, 0), 2) as poi_density_clean,
        round((c.touristic_sites_poi_count - s.min_sites) / nullif(s.max_sites - s.min_sites, 0), 2) as touristic_sites_poi_count,

        round(
            case 
                when c.avg_growth_last_5_years >= 0 and s.max_growth != 0 then c.avg_growth_last_5_years / s.max_growth
                when c.avg_growth_last_5_years < 0 and s.min_growth != 0 then c.avg_growth_last_5_years / abs(s.min_growth)
                else 0
            end, 
        2) as avg_growth_last_5_years

    from cleaned c
    cross join stats s

)

select * from normalized;


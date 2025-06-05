with geographical_referential as (
    select
    municipality_code,
    city_name_normalized,
    latitude,
    longitude
    from {{ref('stg_prello_france__geographical_referential')}}
),

average_salary as (
    select 
    municipality_code,
    avg_net_salary
    from {{ ref('int_prello_france_kpi_avg_net_salary') }}
),

count_tourist_est_poi as (
    select
    municipality_code,
    count_tourist_poi,
    count_tourist_poi_normalized
    from {{ ref('int_prello_france_kpi_count_tourist_poi')}}
),

housing_stress_index as (
    select
    municipality_code,
    housing_stress_index_normalized
    from {{ref('int_prello_france_kpi_housing_stress_index')}}
),

population_growth_5_year as (
    select
    municipality_code,
    avg_growth_last_5_years
    from {{ref('int_prello_france_kpi_percentage_population_growth')}}
),

population_growth_5_year_normalized as (
    select
    municipality_code,
    avg_growth_last_5_years_normalized
    from {{ref('int_prello_france_kpi_population_growth_rate_normalized')}}
),

poi_density_touristic_sites as (
    select
    municipality_code,
    poi_count as touristic_sites_poi_count,
    population,
    poi_density,
    poi_density_normalized,
    poi_count_normalized
    from {{ref('int_prello_france_kpi_poi_density')}}
),

rental_yield as (
    select
    municipality_code,
    rental_med_all,
    median_sales_price_m2_2021,
    rental_yield_yearly,
    rental_yield_normalized
    from {{ref('int_prello_france_kpi_rental_yield')}}
),

establishment_poi_score as (
    select
    municipality_code,
    raw_establishment_score,
    establishment_score_normalized
    from {{ref('int_prello_france_kpi_tourist_poi_score')}}
),

vacancy_rate as (
    select
    municipality_code,
    nb_vacants_housing,
    nb_tot_housing,
    vacancy_rate_normalized
    from {{ref('int_prello_france_kpi_vacancy_rate')}}
), 

second_home_ratio_2 as (
    select
    municipality_code,
    nb_second_home,
    nb_tot_housing  AS nb_tot_housing_shr,
    second_home_ratio,
    second_home_ratio_normalized
    from {{ref('int_prello_france_kpi_second_home_ratio_2')}}
),

sales_price_2 as (
    select
    municipality_code,
    avg_sales_price_m2,
    avg_sales_price_m2_normalized
     from {{ref('int_prello_france_kpi_sales_price_2')}}
),


joined_kpis as (
    select
    gr.municipality_code,
    gr.city_name_normalized,
    gr.latitude,
    gr.longitude,
    cpoi.count_tourist_poi,
    cpoi.count_tourist_poi_normalized,
    pg.avg_growth_last_5_years,
    pgn.avg_growth_last_5_years_normalized,
    pct.touristic_sites_poi_count,
    pct.poi_density,
    pct.poi_density_normalized,
    pct.poi_count_normalized,
    ry.rental_yield_yearly,
    ry.rental_yield_normalized,
    pcs.raw_establishment_score,
    pcs.establishment_score_normalized,
    vr.vacancy_rate_normalized,
    sp2.avg_sales_price_m2   AS avg_sales_price_m2_latest,   -- NEW
    sp2.avg_sales_price_m2_normalized,
    shr.second_home_ratio,
    shr.second_home_ratio_normalized,
    hs.housing_stress_index_normalized


    from geographical_referential gr
    left join average_salary avs on gr.municipality_code = avs.municipality_code
    left join count_tourist_est_poi cpoi on gr.municipality_code = cpoi.municipality_code
    left join housing_stress_index hs on gr.municipality_code = hs.municipality_code
    left join population_growth_5_year pg on gr.municipality_code = pg.municipality_code
    left join population_growth_5_year_normalized pgn on gr.municipality_code = pgn.municipality_code
    left join poi_density_touristic_sites pct on gr.municipality_code = pct.municipality_code
    left join rental_yield ry on gr.municipality_code = ry.municipality_code
    left join establishment_poi_score pcs on gr.municipality_code = pcs.municipality_code
    left join vacancy_rate vr on gr.municipality_code = vr.municipality_code
    left join second_home_ratio_2 shr on gr.municipality_code = shr.municipality_code
    left join sales_price_2 sp2 on gr.municipality_code = sp2.municipality_code
)

select * from joined_kpis

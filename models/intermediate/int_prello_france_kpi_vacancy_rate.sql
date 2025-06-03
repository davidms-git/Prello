with housing as (
    select * from {{ ref('stg_prello_france__housing_stock_clean') }}
),

cleaned as (
    select
        municipality_code,
        year,
        nb_vacants_housing,
        nb_tot_housing
    from housing
    where municipality_code is not null
      and year is not null
      and nb_vacants_housing is not null
      and nb_tot_housing is not null
      and nb_tot_housing > 0
      and year >= 2000
),

vacancy_rate_calc as (
    select
        municipality_code,
        year,
        nb_vacants_housing,
        nb_tot_housing,
        (nb_vacants_housing / nb_tot_housing) * 100 as vacancy_rate
    from cleaned
)

select * from vacancy_rate_calc
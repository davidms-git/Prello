

  create or replace view `prello-france`.`dbt_ddelmor`.`int_prello_france_kpi_vacancy_rate`
  OPTIONS()
  as with housing as (
    select * 
    from `prello-france`.`dbt_ddelmor`.`stg_prello_france__housing_stock_clean`
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

ranked as (
    select *,
           row_number() over (
               partition by municipality_code
               order by year desc
           ) as row_num
    from cleaned
),

most_recent as (
    select *
    from ranked
    where row_num = 1
),

vacancy_rate_calc as (
    select
        municipality_code,
        year,
        nb_vacants_housing,
        nb_tot_housing,
        -- Normalize to 0–1 scale
        safe_divide(nb_vacants_housing, nb_tot_housing) as vacancy_rate_normalized
    from most_recent
)

select * from vacancy_rate_calc;


with population as (
    select * 
    from `prello-france`.`dbt_ddelmor`.`stg_prello_france__poverty_population_by_municipality`
    where municipality_code is not null
      and year is not null
      and population is not null
),

ranked as (
    select *,
           row_number() over (
               partition by municipality_code
               order by year desc
           ) as row_num
    from population
),

-- Filter for the last 6 years (most recent + previous 5)
last_six_years as (
    select *
    from ranked
    where row_num <= 6
),

growth_calc as (
    select
        municipality_code,
        year,
        population,
        lag(population) over (
            partition by municipality_code
            order by year
        ) as previous_population
    from last_six_years
),

yearly_growth as (
    select
        municipality_code,
        year,
        safe_divide(population - previous_population, previous_population) as annual_growth
    from growth_calc
    where previous_population is not null
),

aggregated as (
    select
        municipality_code,
        avg(annual_growth) as avg_growth_last_5_years
    from yearly_growth
    group by municipality_code
)

select *
from aggregated
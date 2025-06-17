with population as (
    select * 
    from {{ ref('stg_prello_france__poverty_population_by_municipality') }}
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

last_year_population as (
    select
        municipality_code,
        year,
        population
    from ranked
    where row_num = 1
)

select *
from last_year_population
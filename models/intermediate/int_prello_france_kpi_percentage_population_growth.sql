with population as (
    select *
    from {{ ref('stg_prello_france__population_by_municipality') }}
),

ranked as (
    select
        population.municipality_code,
        population.year,
        population.population,
        lag(population.population) over (
            partition by population.municipality_code
            order by population.year
        ) as previous_population
    from population
),

growth as (
    select
        municipality_code,
        year,
        population,
        previous_population,
        safe_divide(population - previous_population, previous_population) * 100
            as percentage_population_growth
    from ranked
    where previous_population is not null
)

select *
from growth
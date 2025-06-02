with source as (
    select * 
    from {{ source('prello_france', 'population_by_municipality') }}
),
cleaned as (
    select
        cast(municipality_code as string) as municipality_code,
        cast(year as int) as year,
        population,
        -- Add more fields as needed
    from source
    where municipality_code is not null
      and year is not null
      and year >= 2000
),

final as (
    select
        *,
        concat(municipality_code, '_', cast(year as string)) as id
    from cleaned
)

select * from final
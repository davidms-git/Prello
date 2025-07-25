with 

source as (

    select * from {{ source('prello_france', 'poverty_population_by_municipality') }}

),

renamed as (

    select
        municipality_code,
        year,
        population,
        country_code

    from source

)

select * from renamed

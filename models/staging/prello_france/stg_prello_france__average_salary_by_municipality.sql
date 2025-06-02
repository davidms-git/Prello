with 

source as (

    select * from {{ source('prello_france', 'average_salary_by_municipality') }}

),

renamed as (

    select
        municipality_code,
        avg_net_salary,
        year,
        country_code

    from source

)

select * from renamed

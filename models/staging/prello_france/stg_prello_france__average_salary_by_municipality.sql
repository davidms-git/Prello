with 

source as (

    select * from {{ source('prello_france', 'average_salary_by_municipality') }}

),

cleaned as (

    select
        municipality_code,
        avg_net_salary,
        year

    from source
    where municipality_code is not null 

)

select * from cleaned
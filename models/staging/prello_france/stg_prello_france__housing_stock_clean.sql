with 

source as (

    select * from {{ source('prello_france', 'housing_stock') }}

),

renamed as (

    select
        int64_field_0,
        CAST(year AS STRING) || '_' || CAST(municipality_code AS STRING) AS year_municipality_key,
        municipality_code,
        year,
        nb_principal_home,
        nb_second_home,
        nb_vacants_housing,
        nb_tot_housing,
        secondary_home_rate,
        principal_home_rate,
        vacants_housing_rate

    from source
    where year > 2000

)

select * from renamed

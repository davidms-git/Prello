with 

source as (

    select * from {{ source('prello_france', 'real_estate_info_by_municipality') }}

),

renamed as (

    select
        cast(municipality_code as string) as municipality_code,
        cast(intensite_tension_immo as float64) as intensite_tension_immo,
        cast(rental_max_apartment as float64) as rental_max_apartment,
        cast(rental_min_apartment as float64) as rental_min_apartment,
        cast(rental_med_house as float64) as rental_med_house,
        cast(rental_max_house as float64) as rental_max_house,
        cast(rental_min_house as float64) as rental_min_house,
        cast(rental_med_all as float64) as rental_med_all,
        cast(rental_max_all as float64) as rental_max_all,
        cast(rental_min_all as float64) as rental_min_all

    from source

),

filtered as (

    -- Remove rows with nulls in key fields
    select *
    from renamed
    where municipality_code is not null
      and intensite_tension_immo is not null
      and rental_med_all is not null

)

select* from filtered

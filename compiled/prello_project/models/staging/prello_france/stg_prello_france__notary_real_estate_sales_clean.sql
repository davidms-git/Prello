with 

source as (

    select * from `prello-france`.`prello_france`.`notary_real_estate_sales`

),

renamed as (

    select
        sales_date,
        EXTRACT(YEAR FROM CAST(sales_date AS DATE)) AS year,
        CAST(EXTRACT(YEAR FROM CAST(sales_date AS DATE)) AS STRING) || '_' || CAST(municipality_code AS STRING) AS year_municipality_key,
        sales_amount,
        street_number,
        street_code,
        street_name,
        nom_commune,
        municipality_code,
        premise_type,
        surface,
        number_of_principal_rooms,
        sales_price_m2,
        latitude,
        longitude

    from source
    where EXTRACT(YEAR FROM CAST(sales_date AS DATE)) > 2000
)

select * from renamed
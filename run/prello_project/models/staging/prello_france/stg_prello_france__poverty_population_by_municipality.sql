

  create or replace view `prello-france`.`dbt_ddelmor`.`stg_prello_france__poverty_population_by_municipality`
  OPTIONS()
  as with 

source as (

    select * from `prello-france`.`prello_france`.`poverty_population_by_municipality`

),

renamed as (

    select
        municipality_code,
        year,
        population,
        country_code

    from source

)

select * from renamed;


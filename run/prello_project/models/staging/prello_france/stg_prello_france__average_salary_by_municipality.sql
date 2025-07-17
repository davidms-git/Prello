

  create or replace view `prello-france`.`dbt_ddelmor`.`stg_prello_france__average_salary_by_municipality`
  OPTIONS()
  as with 

source as (

    select * from `prello-france`.`prello_france`.`average_salary_by_municipality`

),

cleaned as (

    select
        municipality_code,
        avg_net_salary,
        year

    from source
    where municipality_code is not null 

)

select * from cleaned;


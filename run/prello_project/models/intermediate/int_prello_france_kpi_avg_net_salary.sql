

  create or replace view `prello-france`.`dbt_ddelmor`.`int_prello_france_kpi_avg_net_salary`
  OPTIONS()
  as with salaries as (

    select *
    from `prello-france`.`dbt_ddelmor`.`stg_prello_france__average_salary_by_municipality`
    where municipality_code is not null
      and year is not null

),

latest_salary as (

    select *
    from salaries
    qualify row_number() over (
        partition by municipality_code
        order by year desc
    ) = 1

)

select *
from latest_salary;


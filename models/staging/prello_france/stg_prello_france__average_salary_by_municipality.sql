with salaries as (

    select *
    from {{ ref('stg_prello_france__average_salary_by_municipality') }}
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
from latest_salary


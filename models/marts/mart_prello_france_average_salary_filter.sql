with salary as (
    select * 
    from {{ source('prello_france', 'average_salary_by_municipality') }}
    where municipality_code is not null
      and year is not null
      and avg_net_salary is not null
),

ranked as (
    select *,
           row_number() over (
               partition by municipality_code
               order by year desc
           ) as row_num
    from salary
)

select
    municipality_code,
    year as salary_year,
    avg_net_salary
from ranked
where row_num = 1
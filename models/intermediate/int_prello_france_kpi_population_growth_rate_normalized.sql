with aggregated as (
    select
        municipality_code,
        avg_growth_last_5_years
    from {{ ref('int_prello_france_kpi_percentage_population_growth') }}
),

pos_range as (
    select
        min(avg_growth_last_5_years) as min_pos,
        max(avg_growth_last_5_years) as max_pos
    from aggregated
    where avg_growth_last_5_years > 0
),

neg_range as (
    select
        min(avg_growth_last_5_years) as min_neg,
        max(avg_growth_last_5_years) as max_neg
    from aggregated
    where avg_growth_last_5_years < 0
),

final as (
    select
        a.municipality_code,
        a.avg_growth_last_5_years,

        case
            when a.avg_growth_last_5_years > 0 then
                (a.avg_growth_last_5_years - p.min_pos) / nullif(p.max_pos - p.min_pos, 0)

            when a.avg_growth_last_5_years < 0 then
                ((a.avg_growth_last_5_years - n.max_neg) / nullif(n.min_neg - n.max_neg, 0)) * -1

            else 0
        end as avg_growth_last_5_years_normalized

    from aggregated a
    left join pos_range p on true
    left join neg_range n on true
)

select *
from final
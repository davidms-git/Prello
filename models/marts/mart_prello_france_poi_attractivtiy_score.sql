with geographical_referential as (
    select
        municipality_code,
        city_name_normalized,
        latitude,
        longitude
    from {{ ref('stg_prello_france__geographical_referential') }}
),

poi_density_touristic_sites as (
    select
        municipality_code,
        poi_count as touristic_sites_poi_count,
        population,
        poi_density
    from {{ ref('int_prello_france_kpi_poi_density') }}
),

establishment_poi_score as (
    select
        municipality_code,
        raw_establishment_score
    from {{ ref('int_prello_france_kpi_tourist_poi_score') }}
),

count_tourist_est_poi as (
    select
        municipality_code,
        count_tourist_poi
    from {{ ref('int_prello_france_kpi_count_tourist_poi') }}
),

joined as (
    select
        gr.municipality_code,
        gr.city_name_normalized,
        gr.latitude,
        gr.longitude,

        -- Use COALESCE to replace nulls with 0
        coalesce(pct.touristic_sites_poi_count, 0) as touristic_sites_poi_count,
        coalesce(pct.poi_density, 0) as poi_density,
        coalesce(pcs.raw_establishment_score, 0) as raw_establishment_score,
        coalesce(cpoi.count_tourist_poi, 0) as count_tourist_poi

    from geographical_referential gr
    left join poi_density_touristic_sites pct using (municipality_code)
    left join establishment_poi_score pcs using (municipality_code)
    left join count_tourist_est_poi cpoi using (municipality_code)
),

-- Calculate min and max for each metric
stats as (
    select
        min(touristic_sites_poi_count) as min_ts_poi,
        max(touristic_sites_poi_count) as max_ts_poi,
        min(poi_density) as min_poi_density,
        max(poi_density) as max_poi_density,
        min(raw_establishment_score) as min_est_score,
        max(raw_establishment_score) as max_est_score,
        min(count_tourist_poi) as min_count_poi,
        max(count_tourist_poi) as max_count_poi
    from joined
),

-- Normalize to 0-1 and compute attractiveness score
final as (
    select
        j.municipality_code,
        j.city_name_normalized,
        j.latitude,
        j.longitude,

        -- Normalize each metric: (value - min) / (max - min)
        case 
            when s.max_ts_poi = s.min_ts_poi then 0
            else (j.touristic_sites_poi_count - s.min_ts_poi) / (s.max_ts_poi - s.min_ts_poi)
        end as norm_touristic_sites_poi_count,

        case 
            when s.max_poi_density = s.min_poi_density then 0
            else (j.poi_density - s.min_poi_density) / (s.max_poi_density - s.min_poi_density)
        end as norm_poi_density,

        case 
            when s.max_est_score = s.min_est_score then 0
            else (j.raw_establishment_score - s.min_est_score) / (s.max_est_score - s.min_est_score)
        end as norm_establishment_score,

        case 
            when s.max_count_poi = s.min_count_poi then 0
            else (j.count_tourist_poi - s.min_count_poi) / (s.max_count_poi - s.min_count_poi)
        end as norm_count_tourist_poi,

        -- Final attractiveness score as sum of normalized values
        (
            case when s.max_ts_poi = s.min_ts_poi then 0 else (j.touristic_sites_poi_count - s.min_ts_poi) / (s.max_ts_poi - s.min_ts_poi) end +
            case when s.max_poi_density = s.min_poi_density then 0 else (j.poi_density - s.min_poi_density) / (s.max_poi_density - s.min_poi_density) end +
            case when s.max_est_score = s.min_est_score then 0 else (j.raw_establishment_score - s.min_est_score) / (s.max_est_score - s.min_est_score) end +
            case when s.max_count_poi = s.min_count_poi then 0 else (j.count_tourist_poi - s.min_count_poi) / (s.max_count_poi - s.min_count_poi) end
        ) as attractiveness_score

    from joined j
    cross join stats s
)

select * from final
order by attractiveness_score DESC
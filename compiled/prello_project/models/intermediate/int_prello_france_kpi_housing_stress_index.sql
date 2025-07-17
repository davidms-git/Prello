with housing as (
    select
        municipality_code,
        intensite_tension_immo
    from `prello-france`.`dbt_ddelmor`.`stg_prello_france__real_estate_info_by_municipality`
),

normalized as (
    select
        municipality_code,
        intensite_tension_immo,
        -- Normalize between 0 and 1 using min 4 and max 31
        (intensite_tension_immo - 4) / (31 - 4) as housing_stress_index_normalized
    from housing
)

select * from normalized
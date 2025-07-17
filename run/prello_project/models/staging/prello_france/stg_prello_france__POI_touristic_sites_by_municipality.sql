

  create or replace view `prello-france`.`dbt_ddelmor`.`stg_prello_france__POI_touristic_sites_by_municipality`
  OPTIONS()
  as WITH source AS (

    SELECT *
    FROM `prello-france`.`prello_france`.`POI_touristic_sites_by_municipality`

),

cleaned AS (

    SELECT DISTINCT
        poi,
        name,
        latitude,
        longitude,
        municipality_code,
        importance,
        name_reprocessed
    FROM source
    WHERE
        municipality_code IS NOT NULL
        AND importance IS NOT NULL
        AND importance > 0

)

SELECT *
FROM cleaned;


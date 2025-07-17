WITH source AS (

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
FROM cleaned
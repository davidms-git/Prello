WITH source AS (

    SELECT *
    FROM {{ source('prello_france', 'POI_tourist_establishments') }}

),

renamed AS (

    SELECT
        poi,
        name,
        latitude,
        longitude,
        municipality_code,
        importance,
        name_reprocessed
    FROM source

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
    FROM renamed
    WHERE
        municipality_code IS NOT NULL
        AND importance IS NOT NULL
        AND importance > 0

)

SELECT *
FROM cleaned
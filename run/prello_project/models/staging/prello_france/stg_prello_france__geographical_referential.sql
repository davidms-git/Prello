

  create or replace view `prello-france`.`dbt_ddelmor`.`stg_prello_france__geographical_referential`
  OPTIONS()
  as 

WITH src AS (

    -- pull the raw table via the source() macro
    SELECT
        municipality_code,
        city_name,
        city_name_normalized,
        municipality_type,
        latitude,
        longitude,
        department_code,
        department_name,
        epci_code                -- keep it for the COALESCE
    FROM `prello-france`.`prello_france`.`geographical_referential`

)

SELECT
    municipality_code,
    city_name,
    city_name_normalized,
    municipality_type,
    latitude,
    longitude,
    department_code,
    epci_code,
    department_name,
FROM src;


WITH latest_salary AS (
    SELECT
        municipality_code,
        ROUND(avg_net_salary, 2) AS avg_net_salary
    FROM {{ ref('stg_prello_france__average_salary_by_municipality') }}
    WHERE avg_net_salary IS NOT NULL
      AND municipality_code IS NOT NULL
      AND year = (
        SELECT MAX(year) FROM {{ ref('stg_prello_france__average_salary_by_municipality') }}
      )
)

SELECT *
FROM latest_salary
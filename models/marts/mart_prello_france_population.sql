select 
    municipality_code,
    population
from {{ref('mart_prello_france_joined_kpis_city_scoring_normalized_david')}}
left join 
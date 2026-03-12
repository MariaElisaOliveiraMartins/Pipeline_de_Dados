with stg_churn as (
    select * from {{ ref('stg_churn') }}
),

dim_geography_pre_clean as (
    select distinct
        -- Usando o nome correto 'geography' que identificamos
        trim(upper(geography)) as country_name
    from stg_churn
    where geography is not null
      and trim(geography) != '' 
)

select 
    {{ dbt_utils.generate_surrogate_key(['country_name']) }} as geography_key,
    country_name
from dim_geography_pre_clean
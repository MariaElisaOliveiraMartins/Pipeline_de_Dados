{{ config(materialized='table') }}

with staging as (
    select * from {{ ref('stg_churn') }}
)

select
    customer_id,
    -- ESTA LINHA É A PONTE PARA O GRÁFICO:
    {{ dbt_utils.generate_surrogate_key(['country_name']) }} as geography_key,
    
    credit_score,
    balance,
    estimated_salary,
    num_of_products,
    has_credit_card,
    is_active_member,
    is_churned,
    round(balance / nullif(estimated_salary, 0), 4) as balance_to_salary_ratio
from staging
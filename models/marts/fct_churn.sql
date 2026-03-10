{{ config(materialized='table') }}

with staging as (
    select * from {{ ref('stg_churn') }}
)

select
    customer_id,
    credit_score,
    balance,
    estimated_salary,
    num_of_products,
    has_credit_card,
    is_active_member,
    is_churned,
    -- Exemplo de métrica calculada: Salário por dependente ou similar poderia entrar aqui
    round(balance / nullif(estimated_salary, 0), 4) as balance_to_salary_ratio
from staging
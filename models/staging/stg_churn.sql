with source as (
    select * from {{ source('raw_data', 'churn_raw') }}
),

renamed as (
    select
        -- Identificadores
        cast(CustomerId as INT64) as customer_id,
        cast(Surname as STRING) as surname,

        -- Atributos
        cast(Geography as STRING) as geography,
        cast(Gender as STRING) as gender,
        cast(Age as INT64) as age,
        cast(Tenure as INT64) as tenure,

        -- Financeiro
        cast(CreditScore as INT64) as credit_score,
        cast(Balance as FLOAT64) as balance,
        cast(EstimatedSalary as FLOAT64) as estimated_salary,

        -- Comportamental
        cast(NumOfProducts as INT64) as num_of_products,
        cast(HasCrCard as INT64) as has_credit_card,
        cast(IsActiveMember as INT64) as is_active_member,
        cast(Exited as INT64) as is_churned

    from source
)

select * from renamed
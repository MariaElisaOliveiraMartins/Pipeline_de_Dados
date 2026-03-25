# dag_churn - processo para o AirFlow

from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

# Argumentos padrão: O "seguro" contra falhas
default_args = {
    'owner': 'MariaElisa',
    'depends_on_past': False,
    'start_date': datetime(2026, 3, 25),
    'retries': 2,                          # Se falhar, tenta 2 vezes
    'retry_delay': timedelta(minutes=5),   # Espera 5 min entre tentativas
}

with DAG(
    'dag_churn_pipeline_bq',
    default_args=default_args,
    description='Orquestrador do Pipeline de Churn - dbt + BigQuery',
    schedule_interval='@daily',            # Roda uma vez por dia
    catchup=False,                         # Não tenta rodar o passado ao ativar
    tags=['churn', 'dbt', 'bigquery']      # Etiquetas para busca na interface
) as dag:

    # Task 1: dbt run (Transformação)
    t1 = BashOperator(
        task_id='dbt_transformation',
        bash_command='dbt run --profiles-dir . --project-dir .' 
    )

    # Task 2: dbt test (Qualidade de Dados)
    t2 = BashOperator(
        task_id='dbt_quality_check',
        bash_command='dbt test --profiles-dir . --project-dir .'
    )

    # A Ordem de Execução: Só testa se a transformação passar
    t1 >> t2
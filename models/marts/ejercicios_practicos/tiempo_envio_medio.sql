
{{
    config(
        materialized = 'ephemeral'
    )
}}
WITH stg_orders AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_orders') }}
    ),

renamed_casted AS (
    SELECT
        count(distinct user_id) as numero_usuarios
    FROM stg_orders
    )

SELECT * FROM renamed_casted
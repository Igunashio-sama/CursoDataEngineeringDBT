
{{
    config(
        materialized = 'ephemeral'
    )
}}
WITH stg_users AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_users') }}
    ),

renamed_casted AS (
    SELECT
        count(distinct user_id) as numero_usuarios
    FROM stg_users
    )

SELECT * FROM renamed_casted
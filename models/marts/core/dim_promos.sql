
{{ 
    config(
        materialized='table'
    ) 
}}

WITH stg_sql_promos AS (
        SELECT * 
        FROM {{ ref('stg_sql_server_dbo_promos') }}
    ),

    renamed_casted AS (
        SELECT
            promo_id
            , promo_name
            , discount_USD
            , status
            , date_load
        FROM stg_sql_promos
    )

SELECT *
FROM renamed_casted
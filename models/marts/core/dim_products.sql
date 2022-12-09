
{{ 
    config(
        materialized="table"
    ) 
}}

WITH stg_sql_products AS (
        SELECT * 
        FROM {{ ref('stg_sql_server_dbo_products') }}
    ),

    renamed_casted AS (
        SELECT
            product_id
            , name
            , price_usd
            , inventory
            , date_load
        FROM stg_sql_products
    )

SELECT *
FROM renamed_casted
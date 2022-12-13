
{{ 
    config(
        materialized='incremental',
        unique_key='product_id',
        on_schema_change='fail'
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

{% if is_incremental() %}
where date_load > (select max(date_load) from {{ this }})
{% endif %}
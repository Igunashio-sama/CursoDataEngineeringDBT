
{{ 
    config(
        materialized='incremental',
        unique_key='promo_id',
        on_schema_change='fail'
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

{% if is_incremental() %}
where date_load > (select max(date_load) from {{ this }})
{% endif %}
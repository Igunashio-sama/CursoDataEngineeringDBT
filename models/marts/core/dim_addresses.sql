
{{
    config(
        materialized='incremental',
        unique_key='address_id',
        on_schema_change='fail'
    )
}}

WITH stg_sql_addresses AS (
        SELECT *
        FROM {{ ref('stg_sql_server_dbo_addresses') }}
),

renamed_casted AS (
    SELECT 
        address_id
        , address
        , zipcode
        , state
        , country
        , date_load
    FROM stg_sql_addresses
)

SELECT * FROM renamed_casted

{% if is_incremental() %}
where date_load > (select max(date_load) from {{ this }})
{% endif %}

{{
    config(
        materialized='table'
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


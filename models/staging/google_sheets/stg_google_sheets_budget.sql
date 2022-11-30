
{{ config(
    materialized='incremental',
    unique_key='budget_id'
    ) 
    }}


WITH stg_budget_products AS (
    SELECT * 
    FROM {{ source('google_sheets','budget') }}
    ),

renamed_casted AS (
    SELECT
          _row as budget_id
        , month
        , product_id
        , quantity 
        , _fivetran_synced as date_load
    FROM stg_budget_products
    )

SELECT * FROM renamed_casted

{% if is_incremental() %}

  where date_load > (select max(date_load) from {{ this }})

{% endif %}
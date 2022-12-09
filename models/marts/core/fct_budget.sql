
{{ config(
    materialized='table'
    ) 
    }}


WITH stg_budget_products AS (
    SELECT * 
    FROM {{ ref('stg_google_sheets_budget') }}
    ),

renamed_casted AS (
    SELECT
          budget_id
        , year(month)*100 + month(month) AS month_year_id
        , product_id
        , quantity 
        , date_load
    FROM stg_budget_products
    )

SELECT * FROM renamed_casted
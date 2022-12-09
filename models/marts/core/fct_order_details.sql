
{{
    config(
        materialized='table'
    )
}}

WITH stg_orders AS (
    SELECT *
    FROM {{ ref('stg_sql_server_dbo_orders') }}
),

stg_orderitems AS (
    SELECT *
    FROM {{ ref('stg_sql_server_dbo_orderitems') }}
),

renamed_casted AS (
    SELECT
        md5(concat(A.order_id, product_id)) order_details_id
        , A.order_id
        , product_id
        , user_id
        , address_id
        , promo_id
        , id_date_created
        , estimated_delivery_at_id
        , delivery_date_id
        , time_created
        , delivery_time
        , shipping_service
        , tracking_id
        , status
        , quantity
        , shipping_cost_USD
        , order_total_USD
    FROM stg_orders A
    JOIN stg_orderitems B
    ON A.order_id = B.order_id
    ORDER BY order_id
)

SELECT * FROM renamed_casted
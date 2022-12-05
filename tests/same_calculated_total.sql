WITH order_data AS (
    SELECT *
    FROM {{ ref('stg_sql_server_dbo_orders') }}
),

calc_orders AS (
    SELECT *
    FROM {{ ref('fct_order_details') }}
),

dim_products AS(
    SELECT *
    FROM {{ ref('dim_products') }}
),

dim_promos AS (
    SELECT *
    FROM {{ ref('dim_promos') }}
)

SELECT
    A.order_id
    , B.order_total_USD
    , CASE
    WHEN A.promo_id is NULL THEN SUM(A.quantity * C.price_usd) + A.shipping_cost_USD
    ELSE SUM(A.quantity * C.price_usd) + A.shipping_cost_USD - D.discount_USD
    END AS calc_total
FROM calc_orders A
JOIN order_data B
ON A.order_id = B.order_id
LEFT JOIN dim_products C
ON A.product_id = C.product_id
LEFT JOIN dim_promos D
ON A.promo_id = D.promo_id
GROUP BY 1, 2, A.shipping_cost_USD, D.discount_USD, A.promo_id
HAVING B.order_total_USD <> calc_total::NUMBER(38,2)
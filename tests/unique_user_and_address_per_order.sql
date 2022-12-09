SELECT
    order_id
    , count(DISTINCT user_id) AS user_per_order
    , count(DISTINCT address_id) AS address_per_order
FROM {{ ref('fct_order_details') }}
GROUP BY 1
HAVING user_per_order <> 1 OR address_per_order <> 1
ORDER BY 1
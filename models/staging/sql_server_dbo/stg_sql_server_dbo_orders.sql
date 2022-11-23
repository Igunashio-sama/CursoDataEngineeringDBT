{{ 
    config(
        materialized='incremental',
        unique_key='order_id',
        on_schema_change='fail'

    ) 
}}

with src_sql_orders as (
        select * 
        from {{ source("sql_server_dbo", "orders") }}
    ),

    renamed_casted as (
        select
            order_id
            , case
                when promo_id is null or promo_id = '' then null
                else md5(trim(promo_id))
            end as promo_id
            , user_id
            , address_id
            , year(created_at)*10000+month(created_at)*100+day(created_at) as id_date_created
            , created_at as time_created
            , order_cost as order_cost_USD
            , shipping_cost as shipping_cost_USD
            , order_total as order_total_USD
            , shipping_service
            , estimated_delivery_at::date as estimated_delivery_at
            , delivered_at::date as delivery_date
            , delivered_at::time as delivery_time
            , status
            , _fivetran_synced as date_load
            , _fivetran_deleted as is_deleted
        from src_sql_orders
    )

select *
from renamed_casted

{% if is_incremental() %}
where date_load > (select max(date_load) from {{ this }})
{% endif %}
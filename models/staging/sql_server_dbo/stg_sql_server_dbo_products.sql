
{{ 
    config(
        materialized="view"
    ) 
}}

with src_sql_products as (
        select * 
        from {{ source("sql_server_dbo", "products") }}
    ),

    renamed_casted as (
        select
            product_id
            , name
            , price as price_usd
            , inventory
            , _fivetran_synced as date_load
            , _fivetran_deleted as is_deleted
        from src_sql_products
    )

select *
from renamed_casted

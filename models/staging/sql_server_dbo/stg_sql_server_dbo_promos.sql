
{{ 
    config(
        materialized='view'
    ) 
}}

with src_sql_promos as (
        select * 
        from {{ source("sql_server_dbo", "promos") }}
    ),

    renamed_casted as (
        select
            md5(trim(promo_id)) as promo_id
            , trim(promo_id) as promo_name
            , discount as discount_USD
            , status
            , _fivetran_synced as date_load
            , _fivetran_deleted as is_deleted
        from src_sql_promos
    )

select *
from renamed_casted
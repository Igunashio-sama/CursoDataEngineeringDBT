
{{ 
    config(
        materialized="view"
    ) 
}}

with src_sql_addresses as (
        select * 
        from {{ source("sql_server_dbo", "addresses") }}
    ),

    renamed_casted as (
        select
            address_id
            , address
            , zipcode
            , state
            , country
            , _fivetran_synced as date_load
            , _fivetran_deleted as is_deleted
        from src_sql_addresses
    )

select *
from renamed_casted

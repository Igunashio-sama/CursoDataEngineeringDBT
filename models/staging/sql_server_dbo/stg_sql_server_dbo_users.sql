
{{ 
    config(
        materialized="table", 
    ) 
}}

with src_sql_users as (
        select * 
        from {{ source("sql_server_dbo", "users") }}
        ),

    renamed_casted as (
        select
            user_id
            , address_id
            , first_name
            , last_name
            , email
            , phone_number
            , year(created_at)*10000+month(created_at)*100+day(created_at) as id_date_created
            , year(created_at)*10000+month(created_at)*100+day(created_at) as id_last_update
            , _fivetran_synced as date_load
            , _fivetran_deleted as is_deleted
        from src_sql_users
    )

select *
from renamed_casted

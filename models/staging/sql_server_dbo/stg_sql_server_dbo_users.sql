
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
            , created_at::date as creation_date
            , updated_at::date as last_update
            , _fivetran_synced as date_load
            , _fivetran_deleted as is_deleted
        from src_sql_users
    )

select *
from renamed_casted

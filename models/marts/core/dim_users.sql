
{{ 
    config(
        materialized="table", 
    ) 
}}

WITH stg_sql_users AS (
        SELECT * 
        FROM {{ ref('stg_sql_server_dbo_users') }}
        ),

    renamed_casted as (
        select
            user_id
            , address_id
            , first_name
            , last_name
            , email
            , phone_number
            , id_date_created
            , id_last_update
            , date_load
        from stg_sql_users
    )

select *
from renamed_casted
{{ 
    config(
        materialized='incremental',
        unique_key='event_id',
        on_schema_change='fail'
    ) 
}}

WITH stg_sql_events AS (
        SELECT * 
        FROM {{ ref('stg_sql_server_dbo_events') }}
    ),

    renamed_casted AS (
        SELECT
            event_id
            , user_id
            , product_id
            , session_id
            , event_type
            , page_url
            , id_date_created
            , time_created
            , date_load
        FROM stg_sql_events
    )

SELECT *
FROM renamed_casted

{% if is_incremental() %}
where date_load > (select max(date_load) from {{ this }})
{% endif %}
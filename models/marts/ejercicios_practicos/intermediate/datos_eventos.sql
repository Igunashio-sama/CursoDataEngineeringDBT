{{
    config(
        materialized = 'ephemeral'
    )
}}

WITH stg_events AS (
    SELECT *
    FROM {{ ref('stg_sql_server_dbo_events') }}
),

event_data AS (
    SELECT 
        event_id
        , session_id
        , time_created
        , user_id
        , {{column_values_to_metrics(ref('stg_sql_server_dbo_events'), 'event_type')}}
    FROM stg_events
    {{ dbt_utils.group_by(4) }}
    ORDER BY session_id
)

select * from event_data
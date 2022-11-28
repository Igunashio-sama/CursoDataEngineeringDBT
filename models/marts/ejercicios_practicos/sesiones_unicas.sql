{{
    config(
        materialized = 'ephemeral'
    )
}}
WITH stg_events AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_events') }}
    ),

renamed_casted AS (
    SELECT
        year(creation_date)*1000000+month(creation_date)*10000+day(creation_date)*100+HOUR(creation_time) as hora
        , count(distinct session_id) as num_sesiones
    FROM stg_events
    group by 1
    )

SELECT avg(num_sesiones) as Media_Sesiones 
FROM renamed_casted
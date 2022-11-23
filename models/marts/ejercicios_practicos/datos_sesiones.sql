{{
    config(
        materialized = 'ephemeral'
    )
}}

{% set event_types = obtener_valores(ref('stg_sql_server_dbo_events'),'event_type') %}

WITH stg_users AS (
    SELECT *
    FROM {{ ref('stg_sql_server_dbo_users') }}
),

datos_eventos AS (
    SELECT *
    FROM {{ ref('datos_eventos') }}
),

datos_sesiones AS (
    SELECT 
        session_id, 
        B.user_id, 
        first_name, 
        last_name, 
        email, 
        min(time_created) as FIRST_EVENT_TIME_UTC, 
        max(time_created) as LAST_EVENT_TIME_UTC,
        datediff(minute, FIRST_EVENT_TIME_UTC, LAST_EVENT_TIME_UTC) as duracion_sesion, 
        {%- for event_type in event_types   %}
            sum({{event_type}}) as {{event_type}}
            {%- if not loop.last %},{% endif -%}
            {% endfor %}
    FROM datos_eventos A
    JOIN stg_users B
    ON A.user_id = B.user_id
    {{ dbt_utils.group_by(5) }}
)

SELECT * FROM datos_sesiones
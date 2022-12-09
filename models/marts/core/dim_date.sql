{{ 
    config(
        materialized='table', 
        sort='date_day',
        dist='date_day',
        pre_hook="alter session set timezone = 'Europe/Madrid'; alter session set week_start = 7;" 
        ) }}

WITH stg_date AS (
    SELECT *
    FROM {{ ref('stg_sql_server_dbo_date') }}
),

renamed_casted AS (
    SELECT
        date_id
        , fecha AS date
        , id_anio_mes AS month_year_id
        , anio_semana_dia AS day_week_year
        , semana AS week
    FROM stg_date
    order by date_id DESC
)


SELECT * FROM renamed_casted
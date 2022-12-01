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
    SELECT DISTINCT
        id_anio_mes as month_year_id
        , anio as year
        , mes as month
        , desc_mes as month_name
    FROM stg_date
    order by month_year_id DESC
)


SELECT * FROM renamed_casted
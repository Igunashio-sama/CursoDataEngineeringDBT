{% macro column_values_to_metrics(table, column) %}
  --Preparamos la query
  {% set query_sql %}
    SELECT DISTINCT {{column}} FROM {{table}}
    {% endset %}
    --Ejecutamos la query    
    {% set results = run_query(query_sql) %}
    --En caso de que se ejecute
    {% if execute %}
    --Devolvemos los valores de la primera columna
        {% set results_list = results.columns[0].values() %}
        {% for value in results_list %}
            SUM(CASE WHEN {{column}} = '{{value}}' THEN 1 ELSE 0 END) AS {{value}}
        {%- if not loop.last %}, {% endif -%}
        {% endfor %}
    {% else %}
        {% set results_list = [] %}
    {% endif %}
{% endmacro %}
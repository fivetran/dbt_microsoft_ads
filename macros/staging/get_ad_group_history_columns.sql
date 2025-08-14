{% macro get_ad_group_history_columns() %}

{% set columns = [
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "name", "datatype": dbt.type_string()},
    {"name": "campaign_id", "datatype": dbt.type_int()},
    {"name": "modified_time", "datatype": dbt.type_timestamp()},
    {"name": "start_date", "datatype": "date"},
    {"name": "end_date", "datatype": "date"},
    {"name": "status", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}

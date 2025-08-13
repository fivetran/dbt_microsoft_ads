{% macro get_keyword_history_columns() %}

{% set columns = [
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "name", "datatype": dbt.type_string()},
    {"name": "modified_time", "datatype": dbt.type_timestamp()},
    {"name": "ad_group_id", "datatype": dbt.type_int()},
    {"name": "match_type", "datatype": dbt.type_string()},
    {"name": "status", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}

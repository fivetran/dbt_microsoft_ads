{% macro get_account_history_columns() %}

{% set columns = [
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "name", "datatype": dbt.type_string()},
    {"name": "last_modified_time", "datatype": dbt.type_timestamp()},
    {"name": "time_zone", "datatype": dbt.type_string()},
    {"name": "currency_code", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}

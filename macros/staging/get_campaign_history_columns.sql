{% macro get_campaign_history_columns() %}

{% set columns = [
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "name", "datatype": dbt.type_string()},
    {"name": "account_id", "datatype": dbt.type_int()},
    {"name": "modified_time", "datatype": dbt.type_timestamp()},
    {"name": "type", "datatype": dbt.type_string()},
    {"name": "time_zone", "datatype": dbt.type_string()},
    {"name": "status", "datatype": dbt.type_string()},
    {"name": "budget", "datatype": dbt.type_float()},
    {"name": "budget_id", "datatype": dbt.type_int()},
    {"name": "budget_type", "datatype": dbt.type_string()},
    {"name": "language", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}

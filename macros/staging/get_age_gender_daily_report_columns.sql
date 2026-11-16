{% macro get_age_gender_daily_report_columns() %}

{% set columns = [
    {"name": "account_id", "datatype": dbt.type_int()},
    {"name": "ad_distribution", "datatype": dbt.type_string()},
    {"name": "ad_group_id", "datatype": dbt.type_int()},
    {"name": "age_group", "datatype": dbt.type_string()},
    {"name": "all_conversions", "datatype": dbt.type_int()},
    {"name": "all_conversions_qualified", "datatype": dbt.type_float()},
    {"name": "all_revenue", "datatype": dbt.type_float()},
    {"name": "campaign_id", "datatype": dbt.type_int()},
    {"name": "clicks", "datatype": dbt.type_int()},
    {"name": "conversions", "datatype": dbt.type_int()},
    {"name": "conversions_qualified", "datatype": dbt.type_float()},
    {"name": "date", "datatype": "date"},
    {"name": "gender", "datatype": dbt.type_string()},
    {"name": "goal", "datatype": dbt.type_string()},
    {"name": "impressions", "datatype": dbt.type_int()},
    {"name": "language", "datatype": dbt.type_string()},
    {"name": "spend", "datatype": dbt.type_float()},
    {"name": "revenue", "datatype": dbt.type_float()}
] %}

{{ microsoft_ads_add_pass_through_columns(base_columns=columns, pass_through_fields=var('microsoft_ads__age_gender_passthrough_metrics')) }}

{{ return(columns) }}

{% endmacro %}

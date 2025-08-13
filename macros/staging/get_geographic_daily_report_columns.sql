{% macro get_geographic_daily_report_columns() %}

{% set columns = [
    {"name": "account_id", "datatype": dbt.type_int()},
    {"name": "ad_distribution", "datatype": dbt.type_string()},
    {"name": "ad_group_id", "datatype": dbt.type_int()},
    {"name": "all_conversions", "datatype": dbt.type_int()},
    {"name": "all_conversions_qualified", "datatype": dbt.type_float()},
    {"name": "all_revenue", "datatype": dbt.type_float()},
    {"name": "bid_match_type", "datatype": dbt.type_string()},
    {"name": "campaign_id", "datatype": dbt.type_int()},
    {"name": "city", "datatype": dbt.type_string()},
    {"name": "clicks", "datatype": dbt.type_int()},
    {"name": "conversions", "datatype": dbt.type_int()},
    {"name": "conversions_qualified", "datatype": dbt.type_float()},
    {"name": "country", "datatype": dbt.type_string()},
    {"name": "county", "datatype": dbt.type_string()},
    {"name": "currency_code", "datatype": dbt.type_string()},
    {"name": "date", "datatype": "date"},
    {"name": "delivered_match_type", "datatype": dbt.type_string()},
    {"name": "device_os", "datatype": dbt.type_string()},
    {"name": "device_type", "datatype": dbt.type_string()},
    {"name": "goal", "datatype": dbt.type_string()},
    {"name": "impressions", "datatype": dbt.type_int()},
    {"name": "language", "datatype": dbt.type_string()},
    {"name": "location_id", "datatype": dbt.type_int()},
    {"name": "location_type", "datatype": dbt.type_string()},
    {"name": "metro_area", "datatype": dbt.type_string()},
    {"name": "most_specific_location", "datatype": dbt.type_string()},
    {"name": "network", "datatype": dbt.type_string()},
    {"name": "postal_code", "datatype": dbt.type_string()},
    {"name": "spend", "datatype": dbt.type_float()},
    {"name": "state", "datatype": dbt.type_string()},
    {"name": "top_vs_other", "datatype": dbt.type_string()},
    {"name": "revenue", "datatype": dbt.type_float()}
] %}

{{ microsoft_ads_add_pass_through_columns(base_columns=columns, pass_through_fields=var('microsoft_ads__geographic_passthrough_metrics')) }}

{{ return(columns) }}

{% endmacro %}
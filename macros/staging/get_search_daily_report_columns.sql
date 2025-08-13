{% macro get_search_daily_report_columns() %}

{% set columns = [
    {"name": "account_id", "datatype": dbt.type_int()},
    {"name": "ad_group_id", "datatype": dbt.type_int()},
    {"name": "ad_id", "datatype": dbt.type_int()},
    {"name": "bid_match_type", "datatype": dbt.type_string()},
    {"name": "campaign_id", "datatype": dbt.type_int()},
    {"name": "clicks", "datatype": dbt.type_int()},
    {"name": "date", "datatype": "date"},
    {"name": "delivered_match_type", "datatype": dbt.type_string()},
    {"name": "device_os", "datatype": dbt.type_string()},
    {"name": "device_type", "datatype": dbt.type_string()},
    {"name": "impressions", "datatype": dbt.type_int()},
    {"name": "keyword_id", "datatype": dbt.type_int()},
    {"name": "language", "datatype": dbt.type_string()},
    {"name": "network", "datatype": dbt.type_string()},
    {"name": "search_query", "datatype": dbt.type_string()},
    {"name": "spend", "datatype": dbt.type_numeric()},
    {"name": "top_vs_other", "datatype": dbt.type_string()},
    {"name": "conversions_qualified", "datatype": dbt.type_int()},
    {"name": "conversions", "datatype": dbt.type_int()},
    {"name": "revenue", "datatype": dbt.type_numeric()},
    {"name": "all_conversions", "datatype": dbt.type_int()},
    {"name": "all_conversions_qualified", "datatype": dbt.type_int()},
    {"name": "all_revenue", "datatype": dbt.type_numeric()}
] %}

{{ microsoft_ads_add_pass_through_columns(base_columns=columns, pass_through_fields=var('microsoft_ads__search_passthrough_metrics'), except_fields=['conversions_qualified', 'conversions', 'revenue', 'all_conversions_qualified', 'all_conversions', 'all_revenue']) }}

{{ return(columns) }}

{% endmacro %}

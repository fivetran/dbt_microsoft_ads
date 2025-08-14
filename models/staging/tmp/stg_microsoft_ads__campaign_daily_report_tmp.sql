{{ config(enabled=var('ad_reporting__microsoft_ads_enabled', True)) }}

{{
    fivetran_utils.union_data(
        table_identifier='campaign_performance_daily_report', 
        database_variable='microsoft_ads_database', 
        schema_variable='microsoft_ads_schema', 
        default_database=target.database,
        default_schema='microsoft_ads',
        default_variable='campaign_performance_daily_report',
        union_schema_variable='microsoft_ads_union_schemas',
        union_database_variable='microsoft_ads_union_databases'
    )
}}
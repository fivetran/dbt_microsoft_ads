{{ config(enabled=var('ad_reporting__microsoft_ads_enabled', True) and var('microsoft_ads__using_geographic_daily_report', False))  }}

{{
    fivetran_utils.union_data(
        table_identifier='geographic_performance_daily_report', 
        database_variable='microsoft_ads_database', 
        schema_variable='microsoft_ads_schema', 
        default_database=target.database,
        default_schema='microsoft_ads',
        default_variable='geographic_performance_daily_report',
        union_schema_variable='microsoft_ads_union_schemas',
        union_database_variable='microsoft_ads_union_databases'
    )
}}
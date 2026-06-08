{{ config(enabled=var('ad_reporting__microsoft_ads_enabled', True)) }}

{% if var('microsoft_ads_union_schemas', []) | length > 0 or var('microsoft_ads_union_databases', []) | length > 0 %}

{{
    fivetran_utils.union_data(
        table_identifier='campaign_history', 
        database_variable='microsoft_ads_database', 
        schema_variable='microsoft_ads_schema', 
        default_database=target.database,
        default_schema='microsoft_ads',
        default_variable='campaign_history',
        union_schema_variable='microsoft_ads_union_schemas',
        union_database_variable='microsoft_ads_union_databases'
    )
}}

{% else %}

{{
    fivetran_utils.union_connections(
        connection_dictionary='microsoft_ads_sources',
        single_source_name='microsoft_ads',
        single_table_name='campaign_history'
    )
}}

{% endif %}
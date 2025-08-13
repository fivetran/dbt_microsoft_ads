{{ config(enabled=var('ad_reporting__microsoft_ads_enabled', True)) }}

with base as (

    select * 
    from {{ ref('stg_microsoft_ads__account_daily_report_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_microsoft_ads__account_daily_report_tmp')),
                staging_columns=get_account_daily_report_columns()
            )
        }}

    
        {{ fivetran_utils.source_relation(
            union_schema_variable='microsoft_ads_union_schemas', 
            union_database_variable='microsoft_ads_union_databases') 
        }}

    from base
),

final as (

    select
        source_relation, 
        date as date_day,
        account_id,
        device_os,
        device_type,
        network,
        currency_code, 
        ad_distribution,
        bid_match_type,
        delivered_match_type,
        top_vs_other,
        coalesce(clicks, 0) as clicks, 
        coalesce(impressions, 0) as impressions,
        coalesce(spend, 0) as spend,
        coalesce(coalesce(cast(conversions_qualified as {{ dbt.type_int() }}), cast(conversions as {{ dbt.type_int() }})), 0) as conversions,
        coalesce(cast(revenue as {{ dbt.type_float() }}), 0) as conversions_value,
        coalesce(cast(all_conversions_qualified as {{ dbt.type_int() }}), 0) as all_conversions   
        -- this report does not have an all_revenue or an all_conversions field

        {{ microsoft_ads_fill_pass_through_columns(pass_through_fields=var('microsoft_ads__account_passthrough_metrics'), except=['conversions', 'conversions_value', 'all_conversions']) }}

    from fields
)

select * 
from final

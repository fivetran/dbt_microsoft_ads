{{ config(enabled=var('ad_reporting__microsoft_ads_enabled', True) and var('microsoft_ads__using_geographic_daily_report', False)) }}

with base as (

    select * 
    from {{ ref('stg_microsoft_ads__geographic_daily_report_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_microsoft_ads__geographic_daily_report_tmp')),
                staging_columns=get_geographic_daily_report_columns()
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
        campaign_id,
        ad_group_id,
        country,
        state as region,
        county,
        postal_code,
        city,
        metro_area,
        location_id,
        location_type,
        most_specific_location,
        currency_code,
        device_os,
        device_type,
        network,
        language,
        ad_distribution,
        bid_match_type,
        delivered_match_type,
        top_vs_other,
        goal,
        coalesce(clicks, 0) as clicks, 
        coalesce(impressions, 0) as impressions,
        coalesce(spend, 0) as spend,
        coalesce(coalesce(cast(conversions_qualified as {{ dbt.type_int() }}), cast(conversions as {{ dbt.type_int() }})), 0) as conversions,
        coalesce(cast(revenue as {{ dbt.type_float() }}), 0) as conversions_value,
        coalesce(coalesce(cast(all_conversions_qualified as {{ dbt.type_int() }}), cast(all_conversions as {{ dbt.type_int() }})), 0) as all_conversions,
        -- sometimes this field comes in as a string
        coalesce(cast(replace(cast(all_revenue as {{ dbt.type_string() }}), ',', '') as {{ dbt.type_float() }}), 0) as all_conversions_value

        {{ microsoft_ads_fill_pass_through_columns(pass_through_fields=var('microsoft_ads__geographic_passthrough_metrics')) }}

    from fields
)

select *
from final
{{ config(enabled=var('ad_reporting__microsoft_ads_enabled', True) and var('microsoft_ads__using_age_gender_daily_report', False)) }}

with base as (

    select * 
    from {{ ref('stg_microsoft_ads__age_gender_daily_report_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_microsoft_ads__age_gender_daily_report_tmp')),
                staging_columns=get_age_gender_daily_report_columns()
            )
        }}
        
    
        {{ fivetran_utils.apply_source_relation(package_name='microsoft_ads') }}

    from base
),

final as (

    select
        source_relation,
        date as date_day,
        account_id,
        campaign_id,
        ad_group_id,
        age_group,
        -- Microsoft age groups follow the <min>-<max> format, and the oldest group is open-ended, such as 65+, which gets a max_age of 100. Other values, such as Unknown, return null.
        case
            when age_group like '%-%' then cast(nullif({{ dbt.split_part('age_group', "'-'", 1) }}, '') as {{ dbt.type_int() }})
            when age_group like '%+' then cast(nullif({{ dbt.replace('age_group', "'+'", "''") }}, '') as {{ dbt.type_int() }})
        end as min_age,
        case
            when age_group like '%-%' then cast(nullif({{ dbt.split_part('age_group', "'-'", 2) }}, '') as {{ dbt.type_int() }})
            when age_group like '%+' then 100
        end as max_age,
        gender,
        language,
        ad_distribution,
        goal,
        coalesce(clicks, 0) as clicks, 
        coalesce(impressions, 0) as impressions,
        coalesce(spend, 0) as spend,
        coalesce(coalesce(cast(conversions_qualified as {{ dbt.type_int() }}), cast(conversions as {{ dbt.type_int() }})), 0) as conversions,
        coalesce(cast(revenue as {{ dbt.type_float() }}), 0) as conversions_value,
        coalesce(coalesce(cast(all_conversions_qualified as {{ dbt.type_int() }}), cast(all_conversions as {{ dbt.type_int() }})), 0) as all_conversions,
        -- sometimes this field comes in as a string
        coalesce(cast(replace(cast(all_revenue as {{ dbt.type_string() }}), ',', '') as {{ dbt.type_float() }}), 0) as all_conversions_value

        {{ microsoft_ads_fill_pass_through_columns(pass_through_fields=var('microsoft_ads__age_gender_passthrough_metrics')) }}

    from fields
)

select *
from final

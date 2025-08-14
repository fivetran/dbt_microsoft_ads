{{ config(enabled=var('ad_reporting__microsoft_ads_enabled', True)) }}

with report as (

    select *
    from {{ ref('stg_microsoft_ads__ad_group_daily_report') }}

), 

ad_groups as (

    select *
    from {{ ref('stg_microsoft_ads__ad_group_history') }}
    where is_most_recent_record = True
),

campaigns as (

    select *
    from {{ ref('stg_microsoft_ads__campaign_history') }}
    where is_most_recent_record = True
),

accounts as (

    select *
    from {{ ref('stg_microsoft_ads__account_history') }}
    where is_most_recent_record = True
),

joined as (

    select
        report.source_relation,
        report.date_day,
        accounts.account_name,
        report.account_id,
        campaigns.campaign_name,
        report.campaign_id,
        ad_groups.ad_group_name,
        report.ad_group_id,
        report.device_os,
        report.device_type,
        report.network,
        report.currency_code,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.spend) as spend,
        sum(report.conversions) as conversions,
        sum(report.conversions_value) as conversions_value, 
        sum(report.all_conversions) as all_conversions,
        sum(report.all_conversions_value) as all_conversions_value

        {{ microsoft_ads_persist_pass_through_columns(pass_through_variable='microsoft_ads__ad_group_passthrough_metrics', transform='sum', coalesce_with=0, exclude_fields=['conversions', 'conversions_value', 'all_conversions', 'all_conversions_value']) }}    
    from report
    left join accounts
        on report.account_id = accounts.account_id
        and report.source_relation = accounts.source_relation
    left join campaigns
        on report.campaign_id = campaigns.campaign_id
        and report.source_relation = campaigns.source_relation
    left join ad_groups
        on report.ad_group_id = ad_groups.ad_group_id
        and report.source_relation = ad_groups.source_relation
    {{ dbt_utils.group_by(12) }}
)

select *
from joined
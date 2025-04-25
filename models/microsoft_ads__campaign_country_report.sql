{{ config(enabled=var('ad_reporting__microsoft_ads_enabled', True) and var('microsoft_ads__using_geographic_daily_report', False)) }}

with report as (

    select *
    from {{ var('geographic_performance_daily_report') }}

),  

campaigns as (

    select *
    from {{ var('campaign_history') }}
    where is_most_recent_record = True

), 

accounts as (

    select *
    from {{ var('account_history') }}
    where is_most_recent_record = True

), 

joined as (

    select
        report.source_relation,
        report.date_day,
        report.country,
        accounts.account_name,
        report.account_id,
        campaigns.campaign_name,
        report.campaign_id,
        campaigns.type as campaign_type,
        campaigns.time_zone as campaign_timezone,
        campaigns.status as campaign_status,
        report.device_os,
        report.device_type,
        report.network,
        report.currency_code,
        report.location_id,
        report.goal,
        campaigns.budget as campaign_budget,
        campaigns.budget_id as campaign_budget_id,
        campaigns.budget_type as campaign_budget_type,
        campaigns.language as campaign_language,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.spend) as spend,
        sum(report.conversions) as conversions,
        sum(report.conversions_value) as conversions_value,
        sum(report.all_conversions) as all_conversions,
        sum(report.all_conversions_value) as all_conversions_value

        {{ microsoft_ads_persist_pass_through_columns(pass_through_variable='microsoft_ads__geographic_passthrough_metrics', transform='sum', coalesce_with=0) }} 

    from report
    left join accounts
        on report.account_id = accounts.account_id
        and report.source_relation = accounts.source_relation
    left join campaigns
        on report.campaign_id = campaigns.campaign_id
        and report.source_relation = campaigns.source_relation
    {{ dbt_utils.group_by(20) }}
)

select *
from joined
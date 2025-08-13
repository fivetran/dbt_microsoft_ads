{{ config(enabled=var('ad_reporting__microsoft_ads_enabled', True)) }}

with report as (

    select *
    from {{ ref('stg_microsoft_ads__account_daily_report') }}

), 

accounts as (

    select *
    from {{ ref('stg_microsoft_ads__account_history') }}
    where is_most_recent_record = True
)

, joined as (

    select
        report.source_relation,
        report.date_day,
        accounts.account_name,
        report.account_id,
        accounts.time_zone as account_timezone,
        report.device_os,
        report.device_type,
        report.network,
        report.currency_code,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.spend) as spend,
        sum(report.conversions) as conversions,
        sum(report.conversions_value) as conversions_value,
        sum(report.all_conversions) as all_conversions
        -- all_conversion_value is not available for the account_report

        {{ microsoft_ads_persist_pass_through_columns(pass_through_variable='microsoft_ads__account_passthrough_metrics', transform='sum', coalesce_with=0, exclude_fields=['conversions_value', 'conversions', 'all_conversions']) }}    
    
    from report
    left join accounts
        on report.account_id = accounts.account_id
        and report.source_relation = accounts.source_relation
    {{ dbt_utils.group_by(9) }}
)

select *
from joined
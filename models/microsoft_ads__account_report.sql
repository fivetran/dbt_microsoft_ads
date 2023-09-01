{{ config(enabled=var('ad_reporting__microsoft_ads_enabled', True)) }}

with report as (

    select *
    from {{ var('account_performance_daily_report') }}

), 

accounts as (

    select *
    from {{ var('account_history') }}
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
        sum(report.spend) as spend

        {{ fivetran_utils.persist_pass_through_columns(pass_through_variable='microsoft_ads__account_passthrough_metrics', transform = 'sum') }}
    from report
    left join accounts
        on report.account_id = accounts.account_id
        and report.source_relation = accounts.source_relation
    {{ dbt_utils.group_by(9) }}
)

select *
from joined
with report as (

    select *
    from {{ var('campaign_performance_daily_report') }}

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
        date_day,
        accounts.account_name,
        accounts.account_id,
        campaigns.campaign_name,
        campaigns.campaign_id,
        campaigns.type as campaign_type,
        campaigns.time_zone as campaign_timezone,
        campaigns.status as campaign_status,
        report.device_os,
        report.device_type,
        report.network,
        report.currency_code,
        sum(clicks) as clicks,
        sum(impressions) as impressions,
        sum(spend) as spend

        {% for metric in var('microsoft_ads__campaign_report_passthrough_metrics',[]) %}
        , sum(report.{{ metric }}) as {{ metric }}
        {% endfor %}
    from report
    left join accounts
        on report.account_id = accounts.account_id
    left join campaigns
        on report.campaign_id = campaigns.campaign_id
    {{ dbt_utils.group_by(12)}}
)

select *
from joined
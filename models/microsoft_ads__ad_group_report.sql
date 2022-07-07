with report as (

    select *
    from {{ var('ad_group_performance_daily_report') }}

), 

ad_groups as (

    select *
    from {{ var('ad_group_history') }}
    where is_most_recent_record = True
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
        ad_groups.ad_group_name,
        ad_groups.ad_group_id,
        report.device_os,
        report.device_type,
        report.network,
        report.currency_code,
        sum(clicks) as clicks,
        sum(impressions) as impressions,
        sum(spend) as spend

        {% for metric in var('microsoft_ads__ad_group_report_passthrough_metrics',[]) %}
        , sum(report.{{ metric }}) as {{ metric }}
        {% endfor %}
    from report
    left join accounts
        on report.account_id = accounts.account_id
    left join campaigns
        on report.campaign_id = campaigns.campaign_id
    left join ad_groups
        on report.ad_group_id = ad_groups.ad_group_id
    {{ dbt_utils.group_by(11)}}
)

select *
from joined
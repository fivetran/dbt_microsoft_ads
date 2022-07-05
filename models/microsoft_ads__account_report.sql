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
        date_day,
        accounts.account_name,
        accounts.account_id,
        accounts.time_zone as account_timezone,
        report.device_os,
        report.device_type,
        report.network,
        report.currency_code,
        sum(clicks) as clicks,
        sum(impressions) as impressions,
        sum(spend) as spend

        {% for metric in var('microsoft_ads__account_report_passthrough_metrics',[]) %}
        , sum(report.{{ metric }}) as {{ metric }}
        {% endfor %}
    from report
    left join accounts
        on report.account_id = accounts.account_id
    {{ dbt_utils.group_by(8)}}
)

select *
from joined
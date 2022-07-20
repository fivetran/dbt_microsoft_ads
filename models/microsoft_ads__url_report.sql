with report as (

    select *
    from {{ var('ad_performance_daily_report') }}

), 

keywords as (
    
    select * 
    from {{ var('keyword_performance_daily_report') }}
),

ads as (

    select *
    from {{ var('ad_history') }}
    where is_most_recent_record = True

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
        report.date_day,
        accounts.account_name,
        accounts.account_id,
        campaigns.campaign_name,
        campaigns.campaign_id,
        ad_groups.ad_group_name,
        ad_groups.ad_group_id,
        ads.ad_name,
        ads.ad_id,
        report.device_os,
        report.device_type,
        report.network,
        report.currency_code,
        {{ dbt_utils.split_part('ads.final_url', "'?'", 1) }} as base_url,
        {{ dbt_utils.get_url_host('ads.final_url') }} as url_host,
        '/' || {{ dbt_utils.get_url_path('ads.final_url') }} as url_path,

        {% if var('microsoft_ads_auto_tagging_enabled', false) %}

        coalesce( {{ dbt_utils.get_url_parameter('ads.final_url', 'utm_source') }} , 'Bing') as utm_source,
        coalesce( {{ dbt_utils.get_url_parameter('ads.final_url', 'utm_medium') }}, 'cpc') as utm_medium,
        coalesce( {{ dbt_utils.get_url_parameter('ads.final_url', 'utm_campaign') }}, campaigns.campaign_name) as utm_campaign,
        coalesce( {{ dbt_utils.get_url_parameter('ads.final_url', 'utm_content') }}, ad_groups.ad_group_name) as utm_content,
        coalesce( {{ dbt_utils.get_url_parameter('ads.final_url', 'utm_term') }}, keywords.keyword_name) as utm_term,

        {% else %}

       {{ dbt_utils.get_url_parameter('ads.final_url', 'utm_source') }} as utm_source,
       {{ dbt_utils.get_url_parameter('ads.final_url', 'utm_medium') }} as utm_medium,
       {{ dbt_utils.get_url_parameter('ads.final_url', 'utm_campaign') }} as utm_campaign,
       {{ dbt_utils.get_url_parameter('ads.final_url', 'utm_content') }} as utm_content,
       {{ dbt_utils.get_url_parameter('ads.final_url', 'utm_term') }} as utm_term,
        {% endif %}

        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.spend) as spend

        {% for metric in var('microsoft_ads__ad_report_passthrough_metrics',[]) %}
        , sum(report.{{ metric }}) as {{ metric }}
        {% endfor %}
    from report
    left join ads
        on report.ad_id = ads.ad_id
    left join ad_groups
        on report.ad_group_id = ad_groups.ad_group_id
    left join campaigns
        on report.campaign_id = campaigns.campaign_id
    left join accounts
        on report.account_id = accounts.account_id
    left join keywords
        on report.ad_id = keywords.ad_id
    {{ dbt_utils.group_by(21) }}
), 

filtered as (

    select * 
    from joined
    where base_url IS NOT NULL
)

select *
from joined
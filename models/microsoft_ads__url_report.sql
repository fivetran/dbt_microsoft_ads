{{ config(enabled=var('ad_reporting__microsoft_ads_enabled', True),
    unique_key = ['source_relation','date_day','account_id','campaign_id','ad_group_id','ad_id','device_os','device_type','network','currency_code'],
    partition_by={
      "field": "date_day",
      "data_type": "date",
      "granularity": "day"
    }
    ) }}

with report as (

    select *
    from {{ var('ad_performance_daily_report') }}

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
        report.source_relation,
        report.date_day,
        accounts.account_name,
        report.account_id,
        campaigns.campaign_name,
        report.campaign_id,
        ad_groups.ad_group_name,
        report.ad_group_id,
        ads.ad_name,
        report.ad_id,
        report.device_os,
        report.device_type,
        report.network,
        report.currency_code,
        {{ dbt.split_part('ads.final_url', "'?'", 1) }} as base_url,
        {{ dbt_utils.get_url_host('ads.final_url') }} as url_host,
        '/' || {{ dbt_utils.get_url_path('ads.final_url') }} as url_path,

        {% if var('microsoft_ads_auto_tagging_enabled', false) %}

        coalesce( {{ microsoft_ads.microsoft_ads_extract_url_parameter('ads.final_url', 'utm_source') }} , 'Bing') as utm_source,
        coalesce( {{ microsoft_ads.microsoft_ads_extract_url_parameter('ads.final_url', 'utm_medium') }}, 'cpc') as utm_medium,
        coalesce( {{ microsoft_ads.microsoft_ads_extract_url_parameter('ads.final_url', 'utm_campaign') }}, campaigns.campaign_name) as utm_campaign,
        coalesce( {{ microsoft_ads.microsoft_ads_extract_url_parameter('ads.final_url', 'utm_content') }}, ad_groups.ad_group_name) as utm_content,
        {% else %}

        {{ microsoft_ads.microsoft_ads_extract_url_parameter('ads.final_url', 'utm_source') }} as utm_source,
        {{ microsoft_ads.microsoft_ads_extract_url_parameter('ads.final_url', 'utm_medium') }} as utm_medium,
        {{ microsoft_ads.microsoft_ads_extract_url_parameter('ads.final_url', 'utm_campaign') }} as utm_campaign,
        {{ microsoft_ads.microsoft_ads_extract_url_parameter('ads.final_url', 'utm_content') }} as utm_content,
        {% endif %}

        {{ microsoft_ads.microsoft_ads_extract_url_parameter('ads.final_url', 'utm_term') }} as utm_term,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.spend) as spend

        {{ fivetran_utils.persist_pass_through_columns(pass_through_variable='microsoft_ads__ad_passthrough_metrics', transform = 'sum') }}
    from report
    left join ads
        on report.ad_id = ads.ad_id
        and report.source_relation = ads.source_relation
    left join ad_groups
        on report.ad_group_id = ad_groups.ad_group_id
        and report.source_relation = ad_groups.source_relation
    left join campaigns
        on report.campaign_id = campaigns.campaign_id
        and report.source_relation = campaigns.source_relation
    left join accounts
        on report.account_id = accounts.account_id
        and report.source_relation = accounts.source_relation
    {{ dbt_utils.group_by(22) }}
), 

filtered as (

    select * 
    from joined

    {% if var('ad_reporting__url_report__using_null_filter', True) %}
        where base_url is not null
    {% endif %}
)

select *
from filtered
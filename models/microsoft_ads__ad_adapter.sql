with report as (

    select *
    from {{ ref('stg_microsoft_ads__ad_performance_daily_report') }}

), ads as (

    select *
    from {{ ref('stg_microsoft_ads__ad_history') }}
    where is_most_recent_version = True

), ad_groups as (

    select *
    from {{ ref('stg_microsoft_ads__ad_group_history') }}
    where is_most_recent_version = True

), campaigns as (

    select *
    from {{ ref('stg_microsoft_ads__campaign_history') }}
    where is_most_recent_version = True

), accounts as (

    select *
    from {{ ref('stg_microsoft_ads__account_history') }}
    where is_most_recent_version = True

), joined as (

    select
        report.date_day,
        accounts.account_name,
        accounts.account_id,
        campaigns.campaign_name,
        campaigns.campaign_id,
        ad_groups.ad_group_name,
        ad_groups.ad_group_id,
        ads.base_url,
        ads.url_host,
        ads.url_path,
        ads.utm_source,
        ads.utm_medium,
        ads.utm_campaign,
        ads.utm_content,
        ads.utm_term,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.spend) as spend
    from report
    left join ads
        on report.ad_id = ads.ad_id
    left join ad_groups
        on report.ad_group_id = ad_groups.ad_group_id
    left join campaigns
        on report.campaign_id = campaigns.campaign_id
    left join accounts
        on report.account_id = accounts.account_id
    {{ dbt_utils.group_by(15) }}

)

select *
from joined
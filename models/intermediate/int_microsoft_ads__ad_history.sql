with base as (

    select * 
    from {{ var('microsoft_ads_ad_history') }}

{% if var('microsoft_auto_tagging_enabled', false) %}
), campaigns as (
    
    select * 
    from {{ var('microsoft_ads_campaign_history') }}

), ad_groups as (
    
    select *
    from {{ var('microsoft_ads_ad_group_history') }}

{% endif %}

), url_fields as (

    select 
        base.*,
        {{ dbt_utils.split_part('base.final_url', "'?'", 1) }} as base_url,
        {{ dbt_utils.get_url_host('base.final_url') }} as url_host,
        '/' || {{ dbt_utils.get_url_path('base.final_url') }} as url_path,

        {% if var('microsoft_auto_tagging_enabled', false) %}

        coalesce( {{ dbt_utils.get_url_parameter('base.final_url', 'utm_source') }} , 'bing') as utm_source,
        coalesce( {{ dbt_utils.get_url_parameter('base.final_url', 'utm_medium') }}, 'cpc') as utm_medium,
        coalesce( {{ dbt_utils.get_url_parameter('base.final_url', 'utm_campaign') }}, campaigns.campaign_name) as utm_campaign,
        coalesce( {{ dbt_utils.get_url_parameter('base.final_url', 'utm_content') }}, ad_groups.ad_group_name) as utm_content,

        {% else %}

        {{ dbt_utils.get_url_parameter('base.final_url', 'utm_source') }} as utm_source,
        {{ dbt_utils.get_url_parameter('base.final_url', 'utm_medium') }} as utm_medium,
        {{ dbt_utils.get_url_parameter('base.final_url', 'utm_campaign') }} as utm_campaign,
        {{ dbt_utils.get_url_parameter('base.final_url', 'utm_content') }} as utm_content,

        {% endif %}

        {{ dbt_utils.get_url_parameter('base.final_url', 'utm_term') }} as utm_term
    from base

    {% if var('microsoft_auto_tagging_enabled', false) %}
    left join ad_groups
        on ad_groups.ad_group_id = base.ad_group_id
        and coalesce(ad_groups.is_most_recent_version, true)

    left join campaigns
    on campaigns.campaign_id = ad_groups.campaign_id
        and coalesce(campaigns.is_most_recent_version, true)

    {% endif %}

)

select * 
from url_fields
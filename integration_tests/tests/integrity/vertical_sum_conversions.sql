{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with account_source as (

    select 
        sum(coalesce(coalesce(conversions_qualified, conversions), 0)) as conversions,
        sum(coalesce(revenue, 0)) as conversions_value
    from {{ source('microsoft_ads', 'account_performance_daily_report') }}
),

account_model as (

    select 
        sum(conversions) as conversions,
        sum(conversions_value) as conversions_value
    from {{ ref('microsoft_ads__account_report') }}
),

ad_source as (

    select 
        sum(coalesce(coalesce(conversions_qualified, conversions), 0)) as conversions,
        sum(coalesce(revenue, 0)) as conversions_value
    from {{ source('microsoft_ads', 'ad_performance_daily_report') }}
),

ad_model as (

    select 
        sum(coalesce(conversions, 0)) as conversions,
        sum(coalesce(conversions_value, 0)) as conversions_value
    from {{ ref('microsoft_ads__ad_report') }}
),

ad_group_source as (

    select 
        sum(coalesce(coalesce(conversions_qualified, conversions), 0)) as conversions,
        sum(coalesce(revenue, 0)) as conversions_value
    from {{ source('microsoft_ads', 'ad_group_performance_daily_report') }}
),

ad_group_model as (

    select 
        sum(coalesce(conversions, 0)) as conversions,
        sum(coalesce(conversions_value, 0)) as conversions_value
    from {{ ref('microsoft_ads__ad_group_report') }}
),

campaign_source as (

    select 
        sum(coalesce(coalesce(conversions_qualified, conversions), 0)) as conversions,
        sum(coalesce(revenue, 0)) as conversions_value
    from {{ source('microsoft_ads', 'campaign_performance_daily_report') }}
),

campaign_model as (

    select 
        sum(coalesce(conversions, 0)) as conversions,
        sum(coalesce(conversions_value, 0)) as conversions_value
    from {{ ref('microsoft_ads__campaign_report') }}
),

url_source as (

    select 
        sum(coalesce(coalesce(ad_performance.conversions_qualified, ad_performance.conversions), 0)) as conversions,
        sum(coalesce(ad_performance.revenue, 0)) as conversions_value
    from {{ source('microsoft_ads', 'ad_performance_daily_report') }} as ad_performance
),

url_model as (

    select 
        sum(coalesce(conversions, 0)) as conversions,
        sum(coalesce(conversions_value, 0)) as conversions_value
    from {{ ref('microsoft_ads__url_report') }}
),

keyword_source as (

    select 
        sum(coalesce(coalesce(conversions_qualified, conversions), 0)) as conversions,
        sum(coalesce(revenue, 0)) as conversions_value
    from {{ source('microsoft_ads', 'keyword_performance_daily_report') }}
),

keyword_model as (

    select 
        sum(coalesce(conversions, 0)) as conversions,
        sum(coalesce(conversions_value, 0)) as conversions_value
    from {{ ref('microsoft_ads__keyword_report') }}
)

select 
    'ads' as comparison
from ad_model 
join ad_source on true
where abs(ad_model.conversions_value - ad_source.conversions_value) >= .01
    or abs(ad_model.conversions - ad_source.conversions) >= .01

union all 

select 
    'accounts' as comparison
from account_model 
join account_source on true
where abs(account_model.conversions_value - account_source.conversions_value) >= .01
    or abs(account_model.conversions - account_source.conversions) >= .01

union all 

select 
    'ad groups' as comparison
from ad_group_model 
join ad_group_source on true
where abs(ad_group_model.conversions_value - ad_group_source.conversions_value) >= .01
    or abs(ad_group_model.conversions - ad_group_source.conversions) >= .01

union all 

select 
    'campaigns' as comparison
from campaign_model 
join campaign_source on true
where abs(campaign_model.conversions_value - campaign_source.conversions_value) >= .01
    or abs(campaign_model.conversions - campaign_source.conversions) >= .01

union all 

select 
    'keywords' as comparison
from keyword_model 
join keyword_source on true
where abs(keyword_model.conversions_value - keyword_source.conversions_value) >= .01
    or abs(keyword_model.conversions - keyword_source.conversions) >= .01

union all 

select 
    'urls' as comparison
from url_model 
join url_source on true
where abs(url_model.conversions_value - url_source.conversions_value) >= .01
    or abs(url_model.conversions - url_source.conversions) >= .01

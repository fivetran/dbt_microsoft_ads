{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with ad_report as (

    select 
        sum(conversions) as total_conversions,
        sum(conversions_value) as total_value
    from {{ ref('microsoft_ads__ad_report') }}
),

account_report as (

    select 
        sum(conversions) as total_conversions,
        sum(conversions_value) as total_value
    from {{ ref('microsoft_ads__account_report') }}
),

ad_group_report as (

    select 
        sum(conversions) as total_conversions,
        sum(conversions_value) as total_value
    from {{ ref('microsoft_ads__ad_group_report') }}
),

campaign_report as (

    select 
        sum(conversions) as total_conversions,
        sum(conversions_value) as total_value
    from {{ ref('microsoft_ads__campaign_report') }}
),

url_report as (

    select 
        sum(conversions) as total_conversions,
        sum(conversions_value) as total_value
    from {{ ref('microsoft_ads__url_report') }}
), 

keyword_report as (

    select 
        sum(conversions) as total_conversions,
        sum(conversions_value) as total_value
    from {{ ref('microsoft_ads__keyword_report') }}
)

select 
    'ad vs account' as comparison
from ad_report 
join account_report on true
where ad_report.total_value != account_report.total_value
    or ad_report.total_conversions != account_report.total_conversions

union all 

select 
    'ad vs ad group' as comparison
from ad_report 
join ad_group_report on true
where ad_report.total_value != ad_group_report.total_value
    or ad_report.total_conversions != ad_group_report.total_conversions

union all 

select 
    'ad vs campaign' as comparison
from ad_report 
join campaign_report on true
where ad_report.total_value != campaign_report.total_value
    or ad_report.total_conversions != campaign_report.total_conversions

union all 

select 
    'ad vs url' as comparison
from ad_report 
join url_report on true
where ad_report.total_value != url_report.total_value
    or ad_report.total_conversions != url_report.total_conversions

union all 

select 
    'ad vs keyword' as comparison
from ad_report 
join keyword_report on true
where ad_report.total_value != keyword_report.total_value
    or ad_report.total_conversions != keyword_report.total_conversions
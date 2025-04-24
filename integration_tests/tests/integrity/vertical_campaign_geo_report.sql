{{ config(
    tags=["fivetran_validations"],
    enabled=var('fivetran_validation_tests_enabled', false)
        and var('microsoft_ads__using_geographic_daily_report', false)
) }}

with staging_aggregated as (

    select 
        campaign_id,
        count(distinct date_day) as count_unique_days,
        sum(impressions) as total_impressions,
        sum(clicks) as total_clicks,
        sum(spend) as total_spend,
        sum(conversions) as total_conversions,
        sum(conversions_value) as total_conversions_value,
        sum(all_conversions) as total_all_conversions,
        sum(all_conversions_value) as total_all_conversions_value
    from {{ ref('stg_microsoft_ads__geographic_daily_report') }}
    group by campaign_id
),

country_report_aggregated as (

    select 
        campaign_id,
        count(distinct date_day) as count_unique_days,
        sum(impressions) as total_impressions,
        sum(clicks) as total_clicks,
        sum(spend) as total_spend,
        sum(conversions) as total_conversions,
        sum(conversions_value) as total_conversions_value,
        sum(all_conversions) as total_all_conversions,
        sum(all_conversions_value) as total_all_conversions_value
    from {{ ref('microsoft_ads__campaign_country_report') }}
    group by campaign_id
),

region_report_aggregated as (

    select 
        campaign_id, 
        count(distinct date_day) as count_unique_days,
        sum(impressions) as total_impressions,
        sum(clicks) as total_clicks,
        sum(spend) as total_spend,
        sum(conversions) as total_conversions,
        sum(conversions_value) as total_conversions_value,
        sum(all_conversions) as total_all_conversions,
        sum(all_conversions_value) as total_all_conversions_value
    from {{ ref('microsoft_ads__campaign_region_report') }}
    group by campaign_id
),

-- Join and compare staging data with the country report
country_comparison as (

    select 
        'country' as report_type,
        coalesce(country_report_aggregated.campaign_id, staging_aggregated.campaign_id) as campaign_id,
        country_report_aggregated.count_unique_days as end_count_unique_days,
        staging_aggregated.count_unique_days as staging_count_unique_days,
        country_report_aggregated.total_impressions as end_total_impressions,
        staging_aggregated.total_impressions as staging_total_impressions,
        country_report_aggregated.total_clicks as end_total_clicks,
        staging_aggregated.total_clicks as staging_total_clicks,
        country_report_aggregated.total_spend as end_total_spend,
        staging_aggregated.total_spend as staging_total_spend,
        country_report_aggregated.total_conversions as end_total_conversions,
        staging_aggregated.total_conversions as staging_total_conversions,
        country_report_aggregated.total_conversions_value as end_total_conversions_value,
        staging_aggregated.total_conversions_value as staging_total_conversions_value,
        country_report_aggregated.total_all_conversions as end_total_all_conversions,
        staging_aggregated.total_all_conversions as staging_total_all_conversions,
        country_report_aggregated.total_all_conversions_value as end_total_all_conversions_value,
        staging_aggregated.total_all_conversions_value as staging_total_all_conversions_value
    from country_report_aggregated
    full outer join staging_aggregated
        on country_report_aggregated.campaign_id = staging_aggregated.campaign_id
),

-- Join and compare staging data with the region report
region_comparison as (

    select 
        'region' as report_type,
        coalesce(region_report_aggregated.campaign_id, staging_aggregated.campaign_id) as campaign_id,
        region_report_aggregated.count_unique_days as end_count_unique_days,
        staging_aggregated.count_unique_days as staging_count_unique_days,
        region_report_aggregated.total_impressions as end_total_impressions,
        staging_aggregated.total_impressions as staging_total_impressions,
        region_report_aggregated.total_clicks as end_total_clicks,
        staging_aggregated.total_clicks as staging_total_clicks,
        region_report_aggregated.total_spend as end_total_spend,
        staging_aggregated.total_spend as staging_total_spend,
        region_report_aggregated.total_conversions as end_total_conversions,
        staging_aggregated.total_conversions as staging_total_conversions,
        region_report_aggregated.total_conversions_value as end_total_conversions_value,
        staging_aggregated.total_conversions_value as staging_total_conversions_value,
        region_report_aggregated.total_all_conversions as end_total_all_conversions,
        staging_aggregated.total_all_conversions as staging_total_all_conversions,
        region_report_aggregated.total_all_conversions_value as end_total_all_conversions_value,
        staging_aggregated.total_all_conversions_value as staging_total_all_conversions_value
    from region_report_aggregated
    full outer join staging_aggregated
        on region_report_aggregated.campaign_id = staging_aggregated.campaign_id
),

-- Combine both report comparisons
combined_report_comparisons as (

    select * from country_comparison
    union all
    select * from region_comparison
)

-- Return only mismatched records
select *
from combined_report_comparisons
where end_count_unique_days != staging_count_unique_days
    or end_total_impressions != staging_total_impressions
    or end_total_clicks != staging_total_clicks
    or end_total_conversions != staging_total_conversions
    or end_total_all_conversions != staging_total_all_conversions
    or abs(end_total_spend - staging_total_spend) > 0.01
    or abs(end_total_conversions_value - staging_total_conversions_value) > 0.01
    or abs(end_total_all_conversions_value - staging_total_all_conversions_value) > 0.01

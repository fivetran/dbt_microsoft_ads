with adapter as (

    select *
    from {{ ref('microsoft_ads__ad_adapter') }}

), aggregated as (

    select
        date_day,
        account_name,
        account_id,
        campaign_name,
        campaign_id,
        ad_group_name,
        ad_group_id,
        sum(clicks) as clicks,
        sum(impressions) as impressions,
        sum(spend) as spend
    from adapter
    {{ dbt_utils.group_by(7) }}

)

select *
from aggregated
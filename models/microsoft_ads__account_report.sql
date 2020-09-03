with adapter as (

    select *
    from {{ ref('microsoft_ads__ad_adapter') }}

), aggregated as (

    select
        date_day,
        account_name,
        account_id,
        sum(clicks) as clicks,
        sum(impressions) as impressions,
        sum(spend) as spend
    from adapter
    {{ dbt_utils.group_by(3) }}

)

select *
from aggregated
{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with prod as (
    select
        keyword_id,
        sum(clicks) as clicks, 
        sum(impressions) as impressions,
        sum(spend) as spend
    from {{ target.schema }}_microsoft_ads_prod.microsoft_ads__keyword_report
    group by 1
),

dev as (
    select
        keyword_id,
        sum(clicks) as clicks, 
        sum(impressions) as impressions,
        sum(spend) as spend
    from {{ target.schema }}_microsoft_ads_dev.microsoft_ads__keyword_report
    group by 1
),

final as (
    select 
        prod.keyword_id,
        prod.clicks as prod_clicks,
        dev.clicks as dev_clicks,
        prod.impressions as prod_impressions,
        dev.impressions as dev_impressions,
        prod.spend as prod_spend,
        dev.spend as dev_spend
    from prod
    full outer join dev 
        on dev.keyword_id = prod.keyword_id
)

select *
from final
where
    abs(prod_clicks - dev_clicks) >= .01
    or abs(prod_impressions - dev_impressions) >= .01
    or abs(prod_spend - dev_spend) >= .01
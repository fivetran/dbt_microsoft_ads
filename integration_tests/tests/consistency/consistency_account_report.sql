{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with prod as (
    select
        account_id,
        sum(clicks) as clicks, 
        sum(impressions) as impressions,
        sum(spend) as spend
        {# sum(conversions) as conversions,
        sum(conversions_value) as conversions_value,
        sum(all_conversions) as all_conversions #}
    from {{ target.schema }}_microsoft_ads_prod.microsoft_ads__account_report
    group by 1
),

dev as (
    select
        account_id,
        sum(clicks) as clicks, 
        sum(impressions) as impressions,
        sum(spend) as spend
        {# sum(conversions) as conversions,
        sum(conversions_value) as conversions_value,
        sum(all_conversions) as all_conversions #}
    from {{ target.schema }}_microsoft_ads_dev.microsoft_ads__account_report
    group by 1
),

final as (
    select 
        prod.account_id,
        prod.clicks as prod_clicks,
        dev.clicks as dev_clicks,
        prod.impressions as prod_impressions,
        dev.impressions as dev_impressions,
        prod.spend as prod_spend,
        dev.spend as dev_spend
        {# prod.conversions as prod_conversions,
        dev.conversions as dev_conversions,
        prod.conversions_value as prod_conversions_value,
        dev.conversions_value as dev_conversions_value,
        prod.all_conversions as prod_all_conversions,
        dev.all_conversions as dev_all_conversions #}
    from prod
    full outer join dev 
        on dev.account_id = prod.account_id
)

select *
from final
where
    abs(prod_clicks - dev_clicks) >= .01
    or abs(prod_impressions - dev_impressions) >= .01
    or abs(prod_spend - dev_spend) >= .01
    {# or abs(prod_conversions - dev_conversions) >= .01
    or abs(conversions_value - dev_conversions_value) >= .01
    or abs(all_conversions - dev_all_conversions) >= .01 #}
{{ config(enabled=var('ad_reporting__microsoft_ads_enabled', True)) }}

with base as (

    select * 
    from {{ ref('stg_microsoft_ads__campaign_history_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_microsoft_ads__campaign_history_tmp')),
                staging_columns=get_campaign_history_columns()
            )
        }}
        
    
        {{ fivetran_utils.apply_source_relation(package_name='microsoft_ads') }}

    from base
),

final as (

    select
        source_relation, 
        id as campaign_id,
        name as campaign_name,
        account_id,
        modified_time as modified_at,
        type,
        time_zone,
        status,
        budget,
        budget_id,
        budget_type,
        language,
        row_number() over (partition by id {{ fivetran_utils.partition_by_source_relation(package_name='microsoft_ads') }} order by modified_time desc) = 1 as is_most_recent_record
    from fields
)

select * 
from final
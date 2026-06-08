{{ config(enabled=var('ad_reporting__microsoft_ads_enabled', True)) }}

with base as (

    select * 
    from {{ ref('stg_microsoft_ads__ad_group_history_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_microsoft_ads__ad_group_history_tmp')),
                staging_columns=get_ad_group_history_columns()
            )
        }}
        
    
        {{ fivetran_utils.apply_source_relation(package_name='microsoft_ads') }}

    from base
),

final as (

    select
        source_relation, 
        id as ad_group_id,
        name as ad_group_name,
        campaign_id,
        modified_time as modified_at,
        start_date,
        end_date,
        status,
        row_number() over (partition by id {{ fivetran_utils.partition_by_source_relation(package_name='microsoft_ads') }} order by modified_time desc) = 1 as is_most_recent_record
    from fields
)

select * 
from final
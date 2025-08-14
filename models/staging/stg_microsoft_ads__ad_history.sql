{{ config(enabled=var('ad_reporting__microsoft_ads_enabled', True)) }}

with base as (

    select * 
    from {{ ref('stg_microsoft_ads__ad_history_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_microsoft_ads__ad_history_tmp')),
                staging_columns=get_ad_history_columns()
            )
        }}
        
    
        {{ fivetran_utils.source_relation(
            union_schema_variable='microsoft_ads_union_schemas', 
            union_database_variable='microsoft_ads_union_databases') 
        }}

    from base
),

final as (

    select
        source_relation, 
        id as ad_id,
        {{ var('microsoft_ads__ad_name_selector', 'title_part_1') }} as ad_name,
        title,
        title_part_1,
        title_part_2,
        title_part_3,
        final_url,
        domain,
        ad_group_id,
        modified_time as modified_at,
        status,
        type,
        row_number() over (partition by source_relation, id order by modified_time desc) = 1 as is_most_recent_record
    from fields
)

select * 
from final

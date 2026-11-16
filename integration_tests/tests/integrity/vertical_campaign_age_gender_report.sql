{{ config(
    tags=["fivetran_validations"],
    enabled=var('fivetran_validation_tests_enabled', false)
        and var('microsoft_ads__using_age_gender_daily_report', false)
) }}

{% set metrics = ['impressions', 'clicks', 'spend', 'conversions', 'conversions_value', 'all_conversions', 'all_conversions_value'] %}

with staging_aggregated as (

    select 
        campaign_id,
        date_day
        {% for metric in metrics %}
        , sum({{ metric }}) as {{ metric }}
        {% endfor %}
    from {{ ref('stg_microsoft_ads__age_gender_daily_report') }}
    group by 1,2
),

{% for report in ['age', 'gender'] %}
{{ report }}_report_aggregated as (

    select 
        campaign_id,
        date_day
        {% for metric in metrics %}
        , sum({{ metric }}) as {{ metric }}
        {% endfor %}
    from {{ ref('microsoft_ads__campaign_' ~ report ~ '_report') }}
    group by 1,2
),

{{ report }}_comparison as (

    select 
        '{{ report }}' as report_type,
        coalesce({{ report }}_report_aggregated.campaign_id, staging_aggregated.campaign_id) as campaign_id,
        coalesce({{ report }}_report_aggregated.date_day, staging_aggregated.date_day) as date_day
        {% for metric in metrics %}
        , {{ report }}_report_aggregated.{{ metric }} as end_{{ metric }}
        , staging_aggregated.{{ metric }} as staging_{{ metric }}
        {% endfor %}
    from {{ report }}_report_aggregated
    full outer join staging_aggregated
        on {{ report }}_report_aggregated.campaign_id = staging_aggregated.campaign_id
        and {{ report }}_report_aggregated.date_day = staging_aggregated.date_day
),
{% endfor %}

combined_report_comparisons as (

    select * from age_comparison
    union all
    select * from gender_comparison
)

select *
from combined_report_comparisons
where 
    {% for metric in metrics %}
    abs(coalesce(end_{{ metric }}, 0) - coalesce(staging_{{ metric }}, 0)) > 0.01
    {% if not loop.last %}or{% endif %}
    {% endfor %}

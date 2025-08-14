{% docs account_id %}
The ID of the account.
{% enddocs %}

{% docs account_name %}
The name of the account.
{% enddocs %}

{% docs account_timezone %}
The time zone associated with this account.
{% enddocs %}

{% docs ad_distribution %}
The distribution medium associated with this record.
{% enddocs %}

{% docs ad_id %}
The ID of the corresponding ad.
{% enddocs %}

{% docs ad_group_status %}
The status of this ad group; see the following [documentation](https://help.ads.microsoft.com/apex/index/3/en/53094) for more information on values and definitions.
{% enddocs %}

{% docs ad_name %}
The name of the corresponding ad; `title_part_1` is used as the default ad name but you may customize this by using the `microsoft_ads__ad_name_selector` variable. For more information, refer to the [README](https://github.com/fivetran/dbt_microsoft_ads/blob/main/README.md#change-how-ad-name-is-determined).
{% enddocs %}

{% docs ad_group_id %}
The ID of the corresponding ad group.
{% enddocs %}

{% docs ad_group_name %}
The name of the corresponding ad group.
{% enddocs %}

{% docs ad_status %}
The status of this ad; see the following [documentation](https://docs.microsoft.com/en-us/advertising/campaign-management-service/adstatus?view=bingads-13) for more information on values and definitions.
{% enddocs%}

{% docs ad_type %}
The ad type associated with this record; see the following [documentation](https://docs.microsoft.com/en-us/advertising/campaign-management-service/adtype?view=bingads-13) for more information on values and definitions.
{% enddocs%}

{% docs bid_match_type %}
The bid match type associated with this record; values include 'Broad', 'Exact', 'Phrase'.
{% enddocs %}

{% docs budget %}
The amount to spend daily across all campaigns that share the budget.
{% enddocs %}

{% docs budget_id %}
The unique Microsoft Advertising identifier of the budget.
{% enddocs %}

{% docs budget_type %}
The budget type determines the pace at which the budget is spent throughout the day.
{% enddocs %}

{% docs budget_association_status %}
Indicates whether or not the campaign is currently spending from the budget mentioned in the BudgetName column. The possible values are `Current` and `Ended`.
{% enddocs %}

{% docs budget_name %}
The name of the budget. This column will be empty for unshared budgets.
{% enddocs %}

{% docs budget_status %}
The budget status. The possible values are `Active` and `Deleted`. This column will be empty for unshared budgets.
{% enddocs %}

{% docs campaign_id %}
The ID of the campaign.
{% enddocs %}

{% docs campaign_name %}
The name of the campaign.
{% enddocs %}

{% docs campaign_status %}
The status of this campaign; see the following [documentation](https://docs.microsoft.com/en-us/advertising/campaign-management-service/campaignstatus?view=bingads-13) for more information on values and definitions.
{% enddocs%}

{% docs campaign_timezone %}
The time zone associated with this campaign.
{% enddocs %}

{% docs campaign_type %}
The campaign type associated with this record; see the following [documentation](https://docs.microsoft.com/en-us/advertising/campaign-management-service/campaigntype?view=bingads-13) for more information on values and definitions.
{% enddocs%}

{% docs clicks %}
The number of clicks that occurred by the grain of the report.
{% enddocs %}

{% docs conversions_qualified %}
Number of [conversions](https://learn.microsoft.com/en-us/advertising/reporting-service/conversionperformancereportcolumn?view=bingads-13#conversionsqualified), measured by completion of an action by a customer after viewing your ad. This will **exclude** any conversions where the conversion goal's [ExcludeFromBidding](https://learn.microsoft.com/en-us/advertising/campaign-management-service/conversiongoal?view=bingads-13#excludefrombidding) property in Microsoft Ads is set to true.
{% enddocs %}

{% docs conversions %}
Number of conversions, measured by completion of an action by a customer after viewing your ad. This will **exclude** any conversions where the convesion goal's [ExcludeFromBidding](https://learn.microsoft.com/en-us/advertising/campaign-management-service/conversiongoal?view=bingads-13#excludefrombidding) property in Microsoft Ads is set to true. This field coalesces the source `conversions_qualifed` and `conversions` fields, and will be 0 if both are null.
{% enddocs %}

{% docs conversions_src %}
(Deprecated in 2022 in favor of `conversions_qualified`) Number of conversions, measured by completion of an action by a customer after viewing your ad. This will **exclude** any conversions where the conversion goal's [ExcludeFromBidding](https://learn.microsoft.com/en-us/advertising/campaign-management-service/conversiongoal?view=bingads-13#excludefrombidding) property in Microsoft Ads is set to true.
{% enddocs %}

{% docs revenue %}
The revenue optionally reported by the advertiser as a result of the `conversions` figure. This will **exclude** revenue from conversions in which the conversion goal's [ExcludeFromBidding](https://learn.microsoft.com/en-us/advertising/campaign-management-service/conversiongoal?view=bingads-13#excludefrombidding) property in Microsoft Ads is set to true.
{% enddocs %}

{% docs all_conversions %}
Number of all conversions, measured by completion of an action by a customer after viewing your ad. This will **include** data from conversions regardless of the value of the conversion goal's [ExcludeFromBidding](https://learn.microsoft.com/en-us/advertising/campaign-management-service/conversiongoal?view=bingads-13#excludefrombidding) property in Microsoft Ads. This field coalesces the source `all_conversions_qualifed` and `all_conversions` fields, and will be 0 if both are null.
{% enddocs %}

{% docs all_conversions_qualified %}
Number of all conversions, measured by completion of an action by a customer after viewing your ad. This will **include** data from conversions regardless of the value of the conversion goal's [ExcludeFromBidding](https://learn.microsoft.com/en-us/advertising/campaign-management-service/conversiongoal?view=bingads-13#excludefrombidding) property in Microsoft Ads.
{% enddocs %}

{% docs all_conversions_src %}
(Deprecated in 2022 in favor of `conversions_qualified`)
Number of all conversions, measured by completion of an action by a customer after viewing your ad. This will **include** revenue from conversions regardless of the value of the conversion goal's [ExcludeFromBidding](https://learn.microsoft.com/en-us/advertising/campaign-management-service/conversiongoal?view=bingads-13#excludefrombidding) property in Microsoft Ads.
{% enddocs %}

{% docs all_revenue %}
The revenue reported by the advertiser as a result of the `all_conversions` figure. This will **include** revenue from conversions regardless of the value of the conversion goal's [ExcludeFromBidding](https://learn.microsoft.com/en-us/advertising/campaign-management-service/conversiongoal?view=bingads-13#excludefrombidding) property in Microsoft Ads.
{% enddocs %}

{% docs currency_code %}
The currency code associated with spend and, if applicable, other metrics associated with currency.
{% enddocs %}

{% docs date_day %}
The date of the performance report.
{% enddocs %}

{% docs delivered_match_type %}
The delivered match type associated with this record; values include 'Broad', 'Exact', 'Phrase'.
{% enddocs %}

{% docs device_os %}
The device operating system associated with this record; values include but may not be limited to 'Windows', 'iOS', 'Android', 'Other', 'BlackBerry' and 'Unknown'.
{% enddocs %}

{% docs device_type %}
The device type associated with this record; values include but may not be limited to 'Computer', 'Smartphone', 'Tablet' and 'Unknown'.
{% enddocs %}

{% docs end_date %}
The date in which this ad group will no longer run.
{% enddocs %}

{% docs final_url %}
The full URL that the ad links to.
{% enddocs %}

{% docs impressions %}
The number of impressions that occurred by the grain of the report.
{% enddocs %}

{% docs is_most_recent_record %} 
Boolean representing whether a record is the most recent version of that record.
{% enddocs %}

{% docs keyword_id %}
The ID of the keyword.
{% enddocs %}

{% docs keyword_name %}
The keyword(s) associated with this record.
{% enddocs %}

{% docs keyword_status %}
The status of this keyword; see the following [documentation](https://docs.microsoft.com/en-us/advertising/campaign-management-service/keywordstatus?view=bingads-13) for more information on values and definitions.
{% enddocs%}

{% docs language %}
The language that the associated ad was viewed in.
{% enddocs %}

{% docs match_type %}
The match type associated with this record; values contain but may not be limited to 'Broad', 'Exact', 'Phrase'. Please refer to Microsoft Ad's [documentation](https://help.ads.microsoft.com/#apex/ads/en/50822/1).
{% enddocs %}

{% docs modified_at %}
The time each version of the object was last modified, i.e. when that version of the object was 'created'.
{% enddocs %}

{% docs network %}
The network associated with this record.
{% enddocs %}

{% docs search_query %}
The search query string associated with this record.
{% enddocs %}

{% docs spend %}
The amount of spend that occurred by the grain of the report.
{% enddocs %}

{% docs start_date%}
The date in which an ad group starts running.
{% enddocs %}

{% docs time_zone %}
The time zone associated with this record.
{% enddocs %}

{% docs top_vs_other %}
The position of the ad associated with this record. For more information, refer to Microsoft [documentation](https://help.ads.microsoft.com/apex/index/22/en/14009).
{% enddocs %}

{% docs source_relation %}
The source of the record if the unioning functionality is being used. If not this field will be empty.
{% enddocs %}

{% docs title %}
The title of the ad.
{% enddocs %}

{% docs title_part_1 %}
Part 1 of the title.
{% enddocs %}

{% docs title_part_2 %}
Part 2 of the title.
{% enddocs %}

{% docs title_part_3 %}
Part 3 of the title.
{% enddocs %}

{% docs domain %}
The associated domain that the ad links to.
{% enddocs %}

{% docs city %}
The city where the user was physically located when they clicked the ad.
{% enddocs %}

{% docs county %}
The county where the user was physically located when they clicked the ad.
{% enddocs %}

{% docs country %}
The country or region where the user was physically located when they clicked the ad.
{% enddocs %}

{% docs goal %}
The name of the goal you set for the conversions you want, meaning actions customers take after clicking your ad.
{% enddocs %}

{% docs location_id %}
The Microsoft Advertising identifier of the location where the user was physically located when they clicked the ad.
{% enddocs %}

{% docs location_type %}
The location type used to deliver ads. Values include "Physical location" and "Location of interest". 

"Physical location" indicates the user was in the corresponding City, Country, MetroArea, or State. "Location of interest" indicates the user was searching for or viewing pages about the location.
{% enddocs %}

{% docs metro_area %}
The metro area (Microsoft Market Area in the United States) where the user was physically located when they clicked the ad.
{% enddocs %}

{% docs most_specific_location %}
The most specific location used to deliver ads. If postal code is available, it is prioritized; otherwise, it may match city or country/region.
{% enddocs %}

{% docs postal_code %}
The postal code where the user was physically located when they clicked the ad.
{% enddocs %}

{% docs state %}
The state or geographic region where the user was physically located when they clicked the ad.
{% enddocs %}

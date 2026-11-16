# Decision Log 

## URL tagging 
By default, Microsoft Ads does not enable autotagging. The `microsoft_ads__url_report` leverages logic to observe this default behavior but also allows for customers to leverage the `microsoft_ads_auto_tagging_enabled` variable for UTM parameters either through the Microsoft auto tag feature or other means of URL tagging simultaneously. For more information, please refer to Microsoft's [documentation](https://help.ads.microsoft.com/#apex/ads/en/56798/2-500).

## Hard Deleted Ads
It has come to our attention that Microsoft Ads allows for certain ads to be hard deleted directly from the application. When this occurs, the record of the respective ad within the `_history` source tables synced by Fivetran is completed removed. As such in each end model, `*_id` fields are explicitly selected from the left side of the join, reports, rather than from entity (i.e. keywords) history tables. This is necessary as Microsoft **hard-deletes** records from history tables, and therefore, daily report fields may have `*_id` values that do not exist in history tables. When this happens, there may be `null` records populated within the entity fields as the record from the history table has been removed, but the record in the report table still exists.

## Age groups and goals in the age and gender reports
Microsoft Advertising reports audience age as a range string, such as `18-24`. The oldest range is open-ended, such as `65+`, and Microsoft uses `Unknown` when it can't determine the age.

We keep the raw `age_group` value and parse it into `min_age` and `max_age` integer columns:
- A range such as `18-24` maps to `min_age = 18` and `max_age = 24`.
- An open-ended range such as `65+` maps to `min_age = 65` and `max_age = 100`. We use 100 as the upper bound so you can filter and bucket ages with `between min_age and max_age`.
- Values that aren't a range, such as `Unknown`, get `null` for both.

The `age_gender_audience_daily_report` source has one row per ad group, age group, gender, language, ad distribution, and goal. Delivery metrics (`impressions`, `clicks`, `spend`) sit on the row with a blank goal. Rows with a goal, such as a custom conversion goal, carry only that goal's conversions, with zero impressions and spend. The `microsoft_ads__campaign_age_report` and `microsoft_ads__campaign_gender_report` models sum across ad groups, languages, ad distributions, and goals. This keeps each segment's conversions on the same row as its spend, and no metric is counted twice.

# dbt_microsoft_ads v0.6.0

## 🚨 Breaking Changes 🚨:
[PR #20](https://github.com/fivetran/dbt_microsoft_ads/pull/20) includes the following breaking changes:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- `packages.yml` has been updated to reflect new default `fivetran/fivetran_utils` version, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.

## 🎉 Features 🎉
- For use in the [dbt_ad_reporting package](https://github.com/fivetran/dbt_ad_reporting), users can now allow records having nulls in url fields to be included in the `ad_reporting__url_report` model. See the [dbt_ad_reporting README](https://github.com/fivetran/dbt_ad_reporting) for more details ([#24](https://github.com/fivetran/dbt_microsoft_ads/pull/24)).
## 🚘 Under the Hood 🚘
- Disabled the `not_null` test for `microsoft_ads__url_report` when null urls are allowed ([#24](https://github.com/fivetran/dbt_microsoft_ads/pull/24)).
- Updated this package's `integration_tests/seeds/microsoft_ads_campaign_performance_daily_report_data` in light of [PR #23](https://github.com/fivetran/dbt_microsoft_ads_source/pull/23) on `dbt_microsoft_ads_source` ([#22](https://github.com/fivetran/dbt_microsoft_ads/pull/22)).

## Contributors:
- @clay-walker - Thank you for opening and providing information on issues [#63](https://github.com/fivetran/dbt_ad_reporting/issues/63) and [#64](https://github.com/fivetran/dbt_ad_reporting/issues/64)! 🎉 

# dbt_microsoft_ads v0.5.2

## 🪳 Bugfix 🪳
[PR #23](https://github.com/fivetran/dbt_microsoft_ads/pull/23) includes the following bug fixes:
- In each end model, `*_id` fields are explicitly selected from the left side of the join, reports, rather than from entity (i.e. keywords) history tables. This is necessary as Microsoft **hard-deletes** records from history tables, and therefore, daily report fields may have `*_id` values that do not exist in history tables. ([#63](https://github.com/fivetran/dbt_ad_reporting/issues/63)).
- Includes the `match_type` field in the uniqueness test on the `microsoft_ads__search_report` model ([#64](https://github.com/fivetran/dbt_ad_reporting/issues/64)).

## Contributors:
- @clay-walker - Thank you for opening and providing information on issues [#63](https://github.com/fivetran/dbt_ad_reporting/issues/63) and [#64](https://github.com/fivetran/dbt_ad_reporting/issues/64)! 🎉 
# dbt_microsoft_ads v0.5.1

## 🪳Bugfix🪳
[PR #17](https://github.com/fivetran/dbt_microsoft_ads/pull/17) incorporates the below bugfixes:
- In v0.5.0, including a join on `keyword_performance_daily_report` caused an unintentional fanout in the `microsoft_ads__url_report` model. We have removed this join and rolled back to the previous logic, which is to use the following logic to extract `utm_term` (Microsoft Ads v0.4.0):
  - `{{ dbt_utils.get_url_parameter('ads.final_url', 'utm_term') }} as utm_term`

# dbt_microsoft_ads v0.5.0
## 🚨 Breaking Changes 
[PR #15](https://github.com/fivetran/dbt_microsoft_ads/pull/15) incorporates these breaking changes:
- `microsoft_ads__ad_adapter` report has been renamed to `microsoft_ads__url_report` to more accurately reflect contents of report.
## 🎉 Feature Enhancements 🎉
[PR #15](https://github.com/fivetran/dbt_microsoft_ads/pull/15) includes the below updates:
- Models have been updated to use level specific performance reporting for more accurate reporting.
- New models have been added:
  - `microsoft_ads__ad_report`
  - `microsoft_ads__keyword_report`
  - `microsoft_ads__search_report`
- New fields have been added to old models.
- `README` updates for easier navigation and use of the package.
- Inclusion of passthrough metrics:
  - `microsoft_ads__account_passthrough_metrics`
  - `microsoft_ads__campaign_passthrough_metrics`
  - `microsoft_ads__ad_group_passthrough_metrics`
  - `microsoft_ads__ad_passthrough_metrics`
  - `microsoft_ads__keyword_passthrough_metrics`
  - `microsoft_ads__search_passthrough_metrics`
> This applies to all passthrough columns within the `dbt_microsoft_ads` package and not just the `microsoft_ads__ad_passthrough_metrics` example.
```yml
vars:
  microsoft_ads__ad_passthrough_metrics:
    - name: "my_field_to_include" # Required: Name of the field within the source.
      alias: "field_alias" # Optional: If you wish to alias the field within the staging model.
```
- Added testing for better data integrity.
# dbt_microsoft_ads v0.4.1
## Updates
- We have migrated URL and UTM logic into the "modeling" package in order to adhere to our definitions of "source" and "modeling" packages; specifically, "source" packages are meant to only do light renaming and subsetting columns from the source while "modeling" packages perform more complex transformations, including string extraction for new fields. 
- Changes include:
  - added `int_microsoft_ads__ad_history` model where logic was previously found in the source package's `stg_microsoft_ads__ad_history` model
  - added `microsoft_auto_tagging_enabled` conditional statements for users who utilize Microsoft Advertising's auto tagging feature. Please check README.md for how to use this feature.

# dbt_microsoft_ads v0.4.0
🎉 dbt v1.0.0 Compatibility 🎉
## 🚨 Breaking Changes 🚨
- Adjusts the `require-dbt-version` to now be within the range [">=1.0.0", "<2.0.0"]. Additionally, the package has been updated for dbt v1.0.0 compatibility. If you are using a dbt version <1.0.0, you will need to upgrade in order to leverage the latest version of the package.
  - For help upgrading your package, I recommend reviewing this GitHub repo's Release Notes on what changes have been implemented since your last upgrade.
  - For help upgrading your dbt project to dbt v1.0.0, I recommend reviewing dbt-labs [upgrading to 1.0.0 docs](https://docs.getdbt.com/docs/guides/migration-guide/upgrading-to-1-0-0) for more details on what changes must be made.
- Upgrades the package dependency to refer to the latest `dbt_microsoft_ads_source`. Additionally, the latest `dbt_microsoft_ads_source` package has a dependency on the latest `dbt_fivetran_utils`. Further, the latest `dbt_fivetran_utils` package also has a dependency on `dbt_utils` [">=0.8.0", "<0.9.0"].
  - Please note, if you are installing a version of `dbt_utils` in your `packages.yml` that is not in the range above then you will encounter a package dependency error.

# dbt_microsoft_ads v0.1.0 -> v0.3.0
Refer to the relevant release notes on the Github repository for specific details for the previous releases. Thank you!

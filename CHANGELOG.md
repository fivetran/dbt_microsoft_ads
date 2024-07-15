# dbt_microsoft_ads v0.8.0

[PR #32](https://github.com/fivetran/dbt_microsoft_ads/pull/32) includes the following updates:

## Under the Hood
- Updated the PR Templates for package maintainers to our most up-to-date standards.
- Added consistency validation test for the `microsoft_ads__campaign_report` table (to be used only by maintainers).

## Parallel Upstream Source Package [Release](https://github.com/fivetran/dbt_microsoft_ads_source/releases/tag/v0.9.0)
This includes upstream updates made in dbt_microsoft_ads_source [PR #31](https://github.com/fivetran/dbt_microsoft_ads_source/pull/31):

### Bug Fixes
- Accommodates when the `budget_name` and `budget_status` fields are populated within the `CAMPAIGN_PERFORMANCE_DAILY_REPORT` source table. These fields are now:
  - Included and documented in the `stg_microsoft_ads__campaign_daily_report` model.
  - Included in uniqueness tests on `stg_microsoft_ads__campaign_daily_report`, as they affect the grain of the report and may have therefore induced uniqueness test failures.
- Added proper documentation for the pre-existing `budget_association_status` field (also from `CAMPAIGN_PERFORMANCE_DAILY_REPORT`).

# dbt_microsoft_ads v0.7.1

[PR #30](https://github.com/fivetran/dbt_microsoft_ads/pull/30) includes the following updates:
## Bug Fixes
- This package now leverages the new `microsoft_ads_extract_url_parameter()` macro for use in parsing out url parameters. This was added to create special logic for Databricks instances not supported by `dbt_utils.get_url_parameter()`.
  - This macro will be replaced with the `fivetran_utils.extract_url_parameter()` macro in the next breaking change of this package.
## Under the Hood
- Included auto-releaser GitHub Actions workflow to automate future releases.

# dbt_microsoft_ads v0.7.0
[PR #28](https://github.com/fivetran/dbt_microsoft_ads/pull/28) includes the following updates:

## Breaking changes
- Updated the following identifiers for consistency with the source name and compatibility with the union schema feature:

| current  | previous |
|----------|----------|
|microsoft_ads_account_performance_daily_report_identifier | microsoft_ads_account_daily_report_identifier |
|microsoft_ads_ad_group_performance_daily_report_identifier | microsoft_ads_ad_group_daily_report_identifier|
|microsoft_ads_ad_performance_daily_report_identifier | microsoft_ads_ad_daily_report_identifier|
|microsoft_ads_campaign_performance_daily_report_identifier | microsoft_ads_campaign_daily_report_identifier|
|microsoft_ads_keyword_performance_daily_report_identifier | microsoft_ads_keyword_daily_report_identifier|
|microsoft_ads_search_query_performance_daily_report_identifier | microsoft_ads_search_query_daily_report_identifier|

- If you are using the previous identifier, be sure to update to the current version!

## Feature update 🎉
- Unioning capability! This adds the ability to union source data from multiple microsoft_ads connectors. Refer to the [Union Multiple Connectors README section](https://github.com/fivetran/dbt_microsoft_ads/blob/main/README.md#union-multiple-connectors) for more details.

## Under the hood 🚘
- In the source package, updated tmp models to union source data using the `fivetran_utils.union_data` macro. 
- To distinguish which source each field comes from, added `source_relation` column in each staging and downstream model and applied the `fivetran_utils.source_relation` macro.
  - The `source_relation` column is included in all joins in the transform package. 
- Updated tests to account for the new `source_relation` column.

[PR #25](https://github.com/fivetran/dbt_microsoft_ads/pull/25) includes the following updates:
- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job.
- Updated the pull request [templates](/.github).

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

# dbt_microsoft_ads v1.2.0

[PR #52](https://github.com/fivetran/dbt_microsoft_ads/pull/52) includes the following updates:

## Documentation
- Updates README with standardized Fivetran formatting

## Under the Hood
- In the `.quickstart.yml` file:
  - Adds `table_variables` for relevant sources to prevent missing sources from blocking downstream Quickstart models.
  - Adds `supported_vars` for Quickstart UI customization,

# dbt_microsoft_ads v1.1.0

[PR #50](https://github.com/fivetran/dbt_microsoft_ads/pull/50) includes the following updates:

## Features
  - Increases the required dbt version upper limit to v3.0.0

# dbt_microsoft_ads v1.0.0

[PR #48](https://github.com/fivetran/dbt_microsoft_ads/pull/48) includes the following updates:

## Breaking Changes

### Source Package Consolidation
- Removed the dependency on the `fivetran/microsoft_ads_source` package.
  - All functionality from the source package has been merged into this transformation package for improved maintainability and clarity.
  - If you reference `fivetran/microsoft_ads_source` in your `packages.yml`, you must remove this dependency to avoid conflicts.
  - Any source overrides referencing the `fivetran/microsoft_ads_source` package will also need to be removed or updated to reference this package.
  - Update any microsoft_ads_source-scoped variables to be scoped to only under this package. See the [README](https://github.com/fivetran/dbt_microsoft_ads/blob/main/README.md) for how to configure the build schema of staging models.
- As part of the consolidation, vars are no longer used to reference staging models, and only sources are represented by vars. Staging models are now referenced directly with `ref()` in downstream models.

### dbt Fusion Compatibility Updates
- Updated package to maintain compatibility with dbt-core versions both before and after v1.10.6, which introduced a breaking change to multi-argument test syntax (e.g., `unique_combination_of_columns`).
- Temporarily removed unsupported tests to avoid errors and ensure smoother upgrades across different dbt-core versions. These tests will be reintroduced once a safe migration path is available.
  - Removed all `dbt_utils.unique_combination_of_columns` tests.
  - Moved `loaded_at_field: _fivetran_synced` under the `config:` block in `src_microsoft_ads.yml`.

## Under the Hood
- Updated conditions in `.github/workflows/auto-release.yml`.
- Added `.github/workflows/generate-docs.yml`.

# dbt_microsoft_ads v0.12.0

[PR #44](https://github.com/fivetran/dbt_microsoft_ads/pull/44) includes the following updates:

## Breaking Change for dbt Core < 1.9.6
> *Note: This is not relevant to Fivetran Quickstart users.*

Migrated `freshness` from a top-level source property to a source `config` in alignment with [recent updates](https://github.com/dbt-labs/dbt-core/issues/11506) from dbt Core ([Source PR #41](https://github.com/fivetran/dbt_microsoft_ads_source/pull/41)). This will resolve the following deprecation warning that users running dbt >= 1.9.6 may have received:

```
[WARNING]: Deprecated functionality
Found `freshness` as a top-level property of `microsoft_ads` in file
`models/src_microsoft_ads.yml`. The `freshness` top-level property should be moved
into the `config` of `microsoft_ads`.
```

**IMPORTANT:** Users running dbt Core < 1.9.6 will not be able to utilize freshness tests in this release or any subsequent releases, as older versions of dbt will not recognize freshness as a source `config` and therefore not run the tests.

If you are using dbt Core < 1.9.6 and want to continue running Microsoft Ads freshness tests, please elect **one** of the following options:
  1. (Recommended) Upgrade to dbt Core >= 1.9.6
  2. Do not upgrade your installed version of the `microsoft_ads` package. Pin your dependency on v0.11.1 in your `packages.yml` file.
  3. Utilize a dbt [override](https://docs.getdbt.com/reference/resource-properties/overrides) to overwrite the package's `microsoft_ads` source and apply freshness via the [old](https://github.com/fivetran/dbt_microsoft_ads_source/blob/main/models/src_microsoft_ads.yml#L11-L13) top-level property route. This will require you to copy and paste the entirety of the `src_microsoft_ads.yml` [file](https://github.com/fivetran/dbt_microsoft_ads_source/blob/main/models/src_microsoft_ads.yml#L4-L494) and add an `overrides: microsoft_ads_source` property.

## Under the Hood
- Updated the package maintainer PR template.

# dbt_microsoft_ads v0.11.1
[PR #43](https://github.com/fivetran/dbt_microsoft_ads/pull/43) includes the following changes:

## Quickstart Fix
- Regenerated docs to ensure manifest picks up new models created in the [v0.11.0 release](https://github.com/fivetran/dbt_microsoft_ads/releases/tag/v0.11.0) to ensure the Quickstart update is properly picked up.

# dbt_microsoft_ads v0.11.0
[PR #41](https://github.com/fivetran/dbt_microsoft_ads/pull/41) includes the following changes:

## Schema Updates

**5 total changes • 0 possible breaking changes**
| Data Model                                     | Change Type | Old Name | New Name                                  | Notes                                                             |
|---------------------------------------------------|-------------|----------|-------------------------------------------|-------------------------------------------------------------------|
| [microsoft_ads__campaign_country_report](https://fivetran.github.io/dbt_microsoft_ads/#!/model/model.microsoft_ads.microsoft_ads__campaign_country_report)       | New Transform Model   |          |  | New table that represents the daily performance of a campaign at the country/geographic region level.               |
| [microsoft_ads__campaign_region_report](https://fivetran.github.io/dbt_microsoft_ads/#!/model/model.microsoft_ads.microsoft_ads__campaign_region_report)       | New Transform Model   |          |  | New table that represents the daily performance of a campaign at the geographic region level.               |
| [stg_microsoft_ads__geographic_daily_report_tmp](https://fivetran.github.io/dbt_microsoft_ads_source/#!/model/model.microsoft_ads_source.stg_microsoft_ads__geographic_daily_report_tmp)      | New Staging Model   |          |  | Temp model added for `geographic_performance_daily_report`.               |
| [stg_microsoft_ads__geographic_daily_report](https://fivetran.github.io/dbt_microsoft_ads_source/#!/model/model.microsoft_ads_source.stg_microsoft_ads__geographic_daily_report)          | New Staging Model   |          |    | Staging model added for `geographic_performance_daily_report`.         |
| [stg_microsoft_ads__campaign_history](https://fivetran.github.io/dbt_microsoft_ads_source/#!/model/model.microsoft_ads_source.stg_microsoft_ads__campaign_history)           | New Columns   |          | `budget`, `budget_id`, `budget_type`, `language`     |        |

## Feature Updates
- Added the `microsoft_ads__campaign_country_report` and `microsoft_ads__campaign_region_report` end models and upstream staging models. See above for schema change details and new models added.
  - For dbt Core users: If you would like to enable these new models you can do so by setting the  `microsoft_ads__using_geographic_daily_report` variable to `true` in your `dbt_project.yml` file (`false` by default). Refer to the [README](https://github.com/fivetran/dbt_microsoft_ads?tab=readme-ov-file#enable-geographic-reports) for more details. 
- Included the `microsoft_ads__geographic_passthrough_metrics` passthrough variable in the above mentioned new staging models. Refer to the [README](https://github.com/fivetran/dbt_microsoft_ads?tab=readme-ov-file#adding-passthrough-metrics) for more details.

# dbt_microsoft_ads v0.10.0
[PR #40](https://github.com/fivetran/dbt_microsoft_ads/pull/40) includes the following changes:

## Feature Update
- Made `ad_name` in `stg_microsoft_ads__ad_history` customizable via a new variable `microsoft_ads__ad_name_selector`. ([PR #39](https://github.com/fivetran/dbt_microsoft_ads_source/pull/39)).
- By default this is determined using `title_part_1`, but you override this by including the configuration shown below in your `dbt_project.yml` file. For more information, refer to the [README](https://github.com/fivetran/dbt_microsoft_ads/blob/main/README.md#change-how-ad-name-is-determined).

```yml
vars:
    microsoft_ads__ad_name_selector: coalesce(title_part_2, title_part_1) # using `title_part_2`, with `title_part_1` as a fallback if the former is `null`.
```

## Documentation
- Added Quickstart model counts to README. ([#39](https://github.com/fivetran/dbt_microsoft_ads/pull/39))
- Corrected references to connectors and connections in the README. ([#39](https://github.com/fivetran/dbt_microsoft_ads/pull/39))
- Updated License.

# dbt_microsoft_ads v0.9.0
[PR #34](https://github.com/fivetran/dbt_microsoft_ads/pull/34) includes the following updates:

## Feature Updates: Conversion Metrics
- We have added the following source fields to each `microsoft_ads` end model:
  - `conversions`: Number of conversions, measured by completion of an action by a customer after viewing your ad.
  - `conversions_value`: The revenue reported by the advertiser as a result of the `conversions` figure.
  - `all_conversions`: Number of *[all](https://learn.microsoft.com/en-us/advertising/reporting-service/conversionperformancereportcolumn?view=bingads-13#allconversions)* conversions, measured by completion of an action by a customer after viewing your ad. This field differs from `conversions` in that it includes conversions associated with a conversion goal in which the [ExcludeFromBidding](https://learn.microsoft.com/en-us/advertising/campaign-management-service/conversiongoal?view=bingads-13#excludefrombidding) Microsoft Ads property is set to `true`.
  - `all_conversions_value` (except `microsoft_ads__account_report`): The revenue reported by the advertiser as a result of the `all_conversions` figure. This field differs from the default `conversions_value` field in that it includes revenue associated with a conversion goal in which the [ExcludeFromBidding](https://learn.microsoft.com/en-us/advertising/campaign-management-service/conversiongoal?view=bingads-13#excludefrombidding) Microsoft Ads property is set to `true`.
> The above new field additions are **breaking changes**.

## Under the Hood
- Created `microsoft_ads_persist_pass_through_columns` macro to ensure that the new conversion fields are backwards compatible for users who have already included them via passthrough fields.
- Added integrity and consistency validation tests within `integration_tests` folder for the transformation models (to be used by maintainers only).
- Updated seed files with new fields to test and validate on local data, provided specific casting to numeric (for currency) and integers.

## Documentation Update
- Updated `microsoft_ads.yml` with new fields mentioned above. 

## Contributors
- [Seer Interactive](https://www.seerinteractive.com/?utm_campaign=Fivetran%20%7C%20Models&utm_source=Fivetran&utm_medium=Fivetran%20Documentation)

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

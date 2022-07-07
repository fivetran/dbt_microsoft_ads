# dbt_microsoft_ads v0.5.0
## 🚨 Breaking Changes 
- `microsoft_ads__ad_adapter` report has been renamed to `microsoft_ads__url_report` to more accurately reflect contents of report.
## 🎉 Feature Enhancements 🎉
- Models have been updated to use level specific performance reporting for more accurate reporting.
- New models have been added:
  - `microsoft_ads__ad_report`
  - `microsoft_ads__keyword_report`
  - `microsoft_ads__search_report`
- New fields have been added to old models.
- `README` updates for easier navigation and use of the package.
- Passthrough metric functionality for more flexible reporting.
- Added testing for better data integrity.
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

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

# Microsoft Advertising 

This package models Microsoft Advertising data from [Fivetran's connector](https://fivetran.com/docs/applications/microsoft-advertising). It uses data in the format described by [this ERD](https://fivetran.com/docs/applications/microsoft-advertising#schemainformation).

The main focus of the package is to transform the core ad object tables into analytics-ready models, including an 'ad adapter' model that can be easily unioned in to other ad platform packages to get a single-view.

## Models

This package contains transformation models that are designed to work simultaneously with our [Microsoft Advertising source package](https://github.com/fivetran/dbt_microsoft_ads_source). A dependency on the source package is declared in this package's `packages.yml` file, so it will automatically download when you run `dbt deps`. The primary outputs of this package are described below.

| **model**                      | **description**                                                                                                  |
| ------------------------------ | ---------------------------------------------------------------------------------------------------------------- |
| microsoft_ads__ad_adapter      | Each record represents the daily ad performance of each ad, including information about the used UTM parameters. |
| microsoft_ads__account_report  | Each record represents the daily ad performance of each account.                                                 |
| microsoft_ads__ad_group_report | Each record represents the daily ad performance of each ad group.                                                |
| microsoft_ads__campaign_report | Each record represents the daily ad performance of each campaign.                                                |

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

## Configuration
By default, this package looks for your Microsoft Advertising data in the `microsoft_ads` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your Microsoft Advertising data is, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    microsoft_ads_schema: your_schema_name
    microsoft_ads_database: your_database_name
```

For additional configurations for the source models, visit the [Microsoft Advertising source package](https://github.com/fivetran/dbt_microsoft_ads_source).

## Contributions

Additional contributions to this package are very welcome! Please create issues or open PRs against `master`. Check out [this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.

## Resources:
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Provide [feedback](https://www.surveymonkey.com/r/DQ7K7WW) on our existing dbt packages or what you'd like to see next
- Learn more about Fivetran [here](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

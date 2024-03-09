Welcome to your new dbt project!

# Project Name:Qualifyze Analytics Project with dbt

## Overview

This project utilizes dbt (data build tool) to transform and analyze data from Google BigQuery. The goal is to answer various business questions by transforming raw datasets into meaningful insights.

## Data Loading and Connection

### Google BigQuery

1. **Loading Data:** Raw datasets were loaded into Google BigQuery from google sheet.
2. **Connection:** dbt is connected to Google BigQuery to leverage its capabilities for data transformation.

## Project Structure

The project is organized into two main folders:

- `raw_data`: Contains raw datasets models obtained from external sources.
- `transformed_data`: Contains the resulting dbt models transformed to answer business questions.

## Schema Tests

The `schema.yml` file under `raw_data` defines tests to ensure data quality in the raw models. Tests include checking for uniqueness, null values, and accepted values.

## Transformations

### Customer Evolution

The `customer_evolution.sql` transformation in `transformed_data` addresses the business question related to customer evolution.

#### Transformation Logic:

- Identifies customers who transitioned from individual audit requests to subscription models.
- Uses the `raw_data_requests` and `raw_data_credit_packages` tables.
- Utilizes the `CASE` statement to categorize customers based on their audit types.
- Generates a `customer_evolution` table.

### Subscription Data Integration

The `subscription_data_integration.sql` transformation in `transformed_data` integrates raw credit package data with customer data.

#### Transformation Logic:

- Joins the `raw_data_credit_packages` and `raw_data_requests` tables.
- Provides insights into different subscription types and their associations with customer profiles.
- Generates a `subscription_integration` table.

### Credit Package Utilization

The `credit_package_utilization.sql` transformation in `transformed_data` analyzes credit package utilization and expiry.

#### Transformation Logic:

- Joins the `raw_data_credit_packages` and `raw_data_requests` tables.
- Tracks credit utilization against expiration dates.
- Provides insights into credit usage rates and unused credits.
- Generates a `credit_package_utilization` table.

## How to Run

1. Ensure your dbt profiles.yml file is correctly configured with your Google BigQuery connection details.
2. Navigate to the root directory of the project in the terminal.
3. Run `dbt run` to execute the transformations.
4. Run `dbt docs generate` to generate documentation.
5. Run `dbt docs serve` to view the documentation in your browser.

## Additional Notes

- Adjust configurations, such as database connections, in the `profiles.yml` file.
- Customize and expand transformations based on evolving business requirements.

Feel free to reach out for further details or assistance.


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [dbt community](https://getdbt.com/community) to learn from other analytics engineers
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

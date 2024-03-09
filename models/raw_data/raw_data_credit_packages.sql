-- models/raw_data/raw_data_requests.sql

-- Configuring the model
{{ config(
    materialized='table',
    unique_key='id_credit_package',
    sort='signature_date'
) }}


-- Defining the raw_data_credit_packages model
WITH raw_data_credit_packages AS (
    SELECT
    *
FROM
    Qualifyze.raw_data_credit_packages
)

SELECT * FROM raw_data_credit_packages
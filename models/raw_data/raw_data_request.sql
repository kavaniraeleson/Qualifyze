-- models/raw_data/raw_data_requests.sql

-- Configuring the model
{{ config(
    materialized='table',
    unique_key='id_request',
    sort='created_date'
) }}

-- Defining the raw_data_requests model
WITH raw_data_request as (
    select * from Qualifyze.raw_data_request
)

SELECT * FROM raw_data_request
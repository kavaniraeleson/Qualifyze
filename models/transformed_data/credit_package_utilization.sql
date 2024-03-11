-- Credit Utilization and Expiry Analysis with Total Credit Left Query
-- This query I select relevant columns and do some data transformation to check status of credit and also claculate days until credit expiry
-- Also I create an insight column to see how the credits are been used.


-- Configuring the model
{{ config(
    materialized='table'
) }}


WITH credit_utilization AS (
     SELECT
        c.id_credit_package,
        c.start_date AS sub_start_date,
        c.end_date AS sub_end_date,
        r.created_date as audit_creation_date,
        c.credits_amount,
        c.id_subscription,
        c.total_value_eur,
        r.customer_name,
        r.audit_type,
        r.price_eur,
        r.id_request,
        CASE
            WHEN c.start_date <= r.created_date AND  c.end_date >= r.created_date  THEN 'Active' 
            WHEN r.created_date >= c.end_date THEN 'Used'
            ELSE 'Unused'
        END AS credit_utilization_status,
        EXTRACT(DAY FROM c.end_date - r.created_date) AS days_until_expiry
    FROM
        {{ref ("raw_data_credit_packages")}} c
    LEFT JOIN
        {{ref ("raw_data_request")}} r ON c.id_organization = r.id_organization

        --WHERE r.customer_name IS NOT NULL
)

SELECT
    id_credit_package,
    id_subscription,
    customer_name,
    sub_start_date,
    sub_end_date,
    audit_creation_date,
    credit_utilization_status,
    days_until_expiry,
    CASE
        WHEN credit_utilization_status = 'Active' THEN 'Partially Used Credits'
        WHEN credit_utilization_status = 'Unused' AND days_until_expiry >= 0 THEN 'Unused Credits (Not Expired Yet)'
        WHEN credit_utilization_status = 'Used' AND days_until_expiry >= 0 THEN 'Expired Credit'
        ELSE 'No Credit'
    END AS insights,
    credits_amount,
    SUM(CASE WHEN credit_utilization_status = 'Active' THEN credits_amount ELSE 0 END) OVER (PARTITION BY id_credit_package ORDER BY sub_end_date) AS total_credits_used,
    credits_amount - SUM(CASE WHEN credit_utilization_status = 'Active' THEN credits_amount ELSE 0 END) OVER (PARTITION BY id_credit_package ORDER BY sub_end_date) AS remaining_credits
FROM
    credit_utilization



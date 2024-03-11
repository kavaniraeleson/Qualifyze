
-- Configuring the model
{{ config(
    materialized='table'
) }}


--   SQL query for Customer Engagement Evolution with Model Switch
---  I create the CTE to check for customers that had activity last year via their creation date, to check those that made request and also those with credit package
---  This model enables the business to track the customers and their different mode of operations from transactional to subscription to also those who transitioned.

WITH Customer_evolution AS (
    SELECT
        r.id_organization,
        r.customer_name,
        MAX(CASE WHEN r.created_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR) THEN 1 ELSE 0 END) AS has_activity_last_year,
        MAX(CASE WHEN r.id_request IS NOT NULL THEN 'True' ELSE 'False' END) AS has_request,
        MAX(CASE WHEN c.id_credit_package IS NOT NULL THEN 'True' ELSE 'False' END) AS has_credit_package
    FROM
        {{ ref('raw_data_request') }}  r
    LEFT JOIN
        {{ ref('raw_data_credit_packages') }}  c ON r.id_organization = c.id_organization
    GROUP BY
        r.id_organization, r.customer_name
)

SELECT
    id_organization,
    customer_name,
    CASE
        WHEN has_activity_last_year = 1 AND has_request = 'True' AND has_credit_package = 'True' THEN 'Transitioned' -- customers who have switched models over the last year
        WHEN has_activity_last_year = 1 AND has_request = 'True' THEN 'Transactional Only'
        WHEN has_activity_last_year = 1 AND has_credit_package = 'True' THEN 'Subscription Only'
        WHEN has_request = 'True' AND has_credit_package = 'False' THEN 'Transactional Only (No Credit Package)'
        WHEN has_request = 'False' AND has_credit_package = 'True' THEN 'Subscription Only (No Request Yet)'
        ELSE 'No Transaction and Subscription'
    END AS customer_evolution
FROM
    Customer_evolution




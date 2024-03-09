
-- Configuring the model
{{ config(
    materialized='table'
) }}


-- SQL query for Customer Engagement Evolution with Model Switch
WITH CustomerEvolutionCTE AS (
    SELECT
        r.id_organization,
        r.customer_name,
        MAX(CASE WHEN r.audit_type = 'EXISTING_AUDIT' THEN 1 ELSE 0 END) AS has_existing_audit,
        MAX(CASE WHEN r.audit_type = 'NEW_AUDIT' THEN 1 ELSE 0 END) AS has_new_audit,
        MAX(CASE WHEN c.id_organization IS NOT NULL THEN 1 ELSE 0 END) AS has_subscription,
        MAX(CASE WHEN r.created_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR) THEN 1 ELSE 0 END) AS has_activity_last_year
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
        WHEN has_activity_last_year = 1 AND has_existing_audit = 1 AND has_new_audit = 1 THEN 'Transitioned'
        WHEN has_activity_last_year = 1 AND has_existing_audit = 1 THEN 'Transactional Only'
        WHEN has_activity_last_year = 1 AND has_new_audit = 1 THEN 'Subscription Only'
        ELSE 'No Audit Data or Activity Last Year'
    END AS customer_evolution
FROM
    CustomerEvolutionCTE




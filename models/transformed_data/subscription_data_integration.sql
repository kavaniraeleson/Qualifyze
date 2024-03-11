-- I created a subscription info CTE on some assumptions
-- The CTE s used to join the tables and calculate aggregated metrics, here the row_number function is used to rank organizations based on total payment within each payment cycle.
-- Then I do some aggregation on the main query to get max price, total and avg credits 
-- The data can be filtered on rank_per_cycle to see customer with highest subscritpion value


-- Configuring the model
{{ config(
    materialized='table'
) }}

WITH Subscription_info AS (
    SELECT
        r.id_organization,
        r.customer_name,
        r.audit_type,
        r.price_eur,
        c.signature_date,
        c.start_date,
        c.end_date,
        c.credits_amount,
        c.total_value_eur,
        c.payment_cycle,
        c.id_credit_package,
        ROW_NUMBER() OVER (PARTITION BY c.payment_cycle ORDER BY c.total_value_eur DESC) AS rank_per_cycle ---- Used to check for each payment cycle the customer with highest subscription value
    FROM
        {{ref ("raw_data_request")}} r
    LEFT JOIN
        {{ref ("raw_data_credit_packages")}} c ON r.id_organization = c.id_organization
)

SELECT

    id_organization,
    customer_name,
    audit_type,
    payment_cycle,
    COUNT (id_credit_package) as total_credit_packages,
    MAX (start_date) AS start_date,
    MAX (end_date) AS end_date,
    ROUND(AVG(credits_amount),2) AS avg_credits,
    SUM(credits_amount) AS total_credits,
    MAX(total_value_eur) AS highest_payment,
   
FROM
    Subscription_info



GROUP BY
    id_organization,
    customer_name,
    audit_type,
    payment_cycle
ORDER BY customer_name

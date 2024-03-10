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
        r.customer_name,
        r.audit_type,
        r.price_eur,
        c.signature_date,
        c.start_date,
        c.end_date,
        c.credits_amount,
        c.total_value_eur,
        c.payment_cycle,
        ROW_NUMBER() OVER (PARTITION BY c.payment_cycle ORDER BY c.total_value_eur DESC) AS rank_per_cycle 
    FROM
        {{ref ("raw_data_request")}} r
    LEFT JOIN
        {{ref ("raw_data_credit_packages")}} c ON r.id_organization = c.id_organization
)

SELECT
    customer_name,
    audit_type,
    MAX(price_eur) AS max_price,
    ROUND(AVG(credits_amount),2) AS avg_credits,
    SUM(credits_amount) AS total_credits,
    MAX(total_value_eur) AS max_payment,
    payment_cycle
FROM
    Subscription_info

GROUP BY
    customer_name,
    audit_type,
    payment_cycle
ORDER BY customer_name

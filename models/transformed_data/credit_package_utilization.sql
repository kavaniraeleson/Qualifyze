-- Credit Utilization and Expiry Analysis with Total Credit Left Query
WITH credit_utilization AS (
     SELECT
        c.id_credit_package,
        c.signature_date,
        c.start_date,
        c.end_date,
        c.credits_amount,
        c.total_value_eur,
        r.customer_name,
        r.audit_type,
        r.price_eur,
        r.id_request,
        CASE
            WHEN r.created_date <= c.end_date THEN 'Used' 
            ELSE 'Unused'
        END AS credit_utilization_status,
        EXTRACT(DAY FROM c.end_date - r.created_date) AS days_until_expiry
    FROM
        {{ref ("raw_data_credit_packages")}} c
    LEFT JOIN
        {{ref ("raw_data_request")}} r ON c.id_organization = r.id_organization
)

SELECT
    id_credit_package,
    signature_date,
    start_date,
    end_date,
    credits_amount,
    total_value_eur,
    customer_name,
    audit_type,
    price_eur,
    credit_utilization_status,
    days_until_expiry,
    CASE
        WHEN credit_utilization_status = 'Used' THEN 'Used Credits'
        WHEN credit_utilization_status = 'Unused' AND days_until_expiry >= 0 THEN 'Unused Credits (Not Expired Yet)'
        ELSE 'Expired)'
    END AS insights,
    SUM(CASE WHEN credit_utilization_status = 'Used' THEN credits_amount ELSE 0 END) OVER (PARTITION BY id_credit_package ORDER BY end_date) AS total_credits_used,
    credits_amount - SUM(CASE WHEN credit_utilization_status = 'Used' THEN credits_amount ELSE 0 END) OVER (PARTITION BY id_credit_package ORDER BY end_date) AS remaining_credits
FROM
    credit_utilization

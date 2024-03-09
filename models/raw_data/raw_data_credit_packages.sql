

-- Defining the raw_data_credit_packages model
WITH raw_data_credit_packages AS (
    SELECT
    id_credit_package,
    signature_date,
    start_date,
    end_date,
    credits_amount,
    total_value_eur,
    payment_cycle,
    id_subscription,
    id_organization
FROM
    Qualifyze.raw_data_credit_packages
)

SELECT * FROM raw_data_credit_packages
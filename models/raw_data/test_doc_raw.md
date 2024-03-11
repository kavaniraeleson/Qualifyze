
# Documenation on the Test File for Raw Data

## Raw Data Request

- **Test**: `unique` on `id_request`
  - **Why**: This ensures each request has a unique identifier, preventing duplicate entries in the dataset.

- **Test**: `not_null` on `created_date`
  - **Why**: Verifies that the `created_date` for each request is populated, ensuring data completenes.

- **Test**: `accepted_values` on `audit_type`
  - **Why**: This test confirms that the values in the `audit_type` column are within the expected set: 'EXISTING_AUDIT' or 'NEW_AUDIT'. This is crucial for maintaining data integrity and consistency in audit type categorization.

## Raw Data Credit Packages

- **Test**: `unique` on `id_credit_package`
  - **Why**: Ensures each credit package has a unique identifier, preventing duplicate entries in the dataset.

- **Test**: `not_null` on `signature_date`
  - **Why**: This validates that the `signature_date` for each credit package is populated, ensuring data accuraccy tracking of credit package timelines.

- **Test**: `not_null` on `start_date`
  - **Why**: Validates that the `start_date` for each credit package is not null for a valid credit package

- **Test**: `not_null` on `end_date`
  - **Why**: Validates that the `end_date` for each credit package is not null and knowing the length of the credit package.

These tests ensures data quality, preventing duplicates, ensuring completeness.

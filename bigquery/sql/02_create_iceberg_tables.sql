-- ============================================
-- File: 02_create_iceberg_tables.sql
-- Purpose: Create Iceberg tables using BigQuery CTAS
--          (data written to Iceberg-managed GCS)
-- Project: gcp-iceberg-dbt
-- Location: europe-west3
-- Execution note:
--   Run this script in BigQuery with Processing location = europe-west3
--   Connection required: europe-west3.iceberg_gcs

-- ============================================

-- Customers
CREATE OR REPLACE TABLE `gcp-iceberg-dbt.analytics_iceberg.customers`
WITH CONNECTION `europe-west3.iceberg_gcs`
OPTIONS (
  table_format = 'ICEBERG',
  file_format  = 'PARQUET',
  storage_uri  = 'gs://gcp-iceberg-dbt-iceberg/iceberg/commerce/customers/'
) AS
SELECT * FROM `gcp-iceberg-dbt.analytics_source.customers_data`;

-- Products
CREATE OR REPLACE TABLE `gcp-iceberg-dbt.analytics_iceberg.products`
WITH CONNECTION `europe-west3.iceberg_gcs`
OPTIONS (
  table_format = 'ICEBERG',
  file_format  = 'PARQUET',
  storage_uri  = 'gs://gcp-iceberg-dbt-iceberg/iceberg/commerce/products/'
) AS
SELECT * FROM `gcp-iceberg-dbt.analytics_source.products_data`;

-- Orders
CREATE OR REPLACE TABLE `gcp-iceberg-dbt.analytics_iceberg.orders`
WITH CONNECTION `europe-west3.iceberg_gcs`
OPTIONS (
  table_format = 'ICEBERG',
  file_format  = 'PARQUET',
  storage_uri  = 'gs://gcp-iceberg-dbt-iceberg/iceberg/commerce/orders/'
) AS
SELECT * FROM `gcp-iceberg-dbt.analytics_source.orders_data`;

-- Order items
CREATE OR REPLACE TABLE `gcp-iceberg-dbt.analytics_iceberg.order_items`
WITH CONNECTION `europe-west3.iceberg_gcs`
OPTIONS (
  table_format = 'ICEBERG',
  file_format  = 'PARQUET',
  storage_uri  = 'gs://gcp-iceberg-dbt-iceberg/iceberg/commerce/order_items/'
) AS
SELECT * FROM `gcp-iceberg-dbt.analytics_source.order_items_data`;

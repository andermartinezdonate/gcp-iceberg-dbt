-- ============================================
-- File: 01_create_iceberg_tables.sql
-- Purpose: Create BigQuery-managed Iceberg tables on GCS
-- Project: gcp-iceberg-dbt
-- Location: europe-west3
-- ============================================

-- Customers
DROP TABLE IF EXISTS `gcp-iceberg-dbt.analytics_iceberg.customers`;

CREATE TABLE `gcp-iceberg-dbt.analytics_iceberg.customers` (
  customer_id STRING,
  email STRING,
  country STRING,
  city STRING,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  is_active BOOL,
  source_system STRING,
  ingested_at TIMESTAMP
)
WITH CONNECTION `europe-west3.iceberg_gcs`
OPTIONS (
  table_format = 'ICEBERG',
  file_format = 'PARQUET',
  storage_uri = 'gs://gcp-iceberg-dbt-raw/raw/commerce/customers/'
);

-- Products
DROP TABLE IF EXISTS `gcp-iceberg-dbt.analytics_iceberg.products`;

CREATE TABLE `gcp-iceberg-dbt.analytics_iceberg.products` (
  product_id STRING,
  sku STRING,
  product_name STRING,
  category STRING,
  brand STRING,
  unit_price FLOAT64,
  currency STRING,
  is_active BOOL,
  ingested_at TIMESTAMP
)
WITH CONNECTION `europe-west3.iceberg_gcs`
OPTIONS (
  table_format = 'ICEBERG',
  file_format = 'PARQUET',
  storage_uri = 'gs://gcp-iceberg-dbt-raw/raw/commerce/products/'
);

-- Orders
DROP TABLE IF EXISTS `gcp-iceberg-dbt.analytics_iceberg.orders`;

CREATE TABLE `gcp-iceberg-dbt.analytics_iceberg.orders` (
  order_id STRING,
  customer_id STRING,
  order_ts TIMESTAMP,
  order_status STRING,
  currency STRING,
  total_amount FLOAT64,
  payment_status STRING,
  source_system STRING,
  ingested_at TIMESTAMP
)
WITH CONNECTION `europe-west3.iceberg_gcs`
OPTIONS (
  table_format = 'ICEBERG',
  file_format = 'PARQUET',
  storage_uri = 'gs://gcp-iceberg-dbt-raw/raw/commerce/orders/'
);

-- Order items
DROP TABLE IF EXISTS `gcp-iceberg-dbt.analytics_iceberg.order_items`;

CREATE TABLE `gcp-iceberg-dbt.analytics_iceberg.order_items` (
  order_item_id STRING,
  order_id STRING,
  product_id STRING,
  quantity INT64,
  unit_price FLOAT64,
  currency STRING,
  line_total_amount FLOAT64,
  item_status STRING,
  ingested_at TIMESTAMP
)
WITH CONNECTION `europe-west3.iceberg_gcs`
OPTIONS (
  table_format = 'ICEBERG',
  file_format = 'PARQUET',
  storage_uri = 'gs://gcp-iceberg-dbt-raw/raw/commerce/order_items/'
);

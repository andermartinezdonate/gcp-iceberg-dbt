-- ============================================
-- File: 01_external_tables.sql
-- Purpose: Register source-of-truth Parquet files
--          as external tables in BigQuery
-- Project: gcp-iceberg-dbt
-- Location: europe-west3
-- ============================================

CREATE SCHEMA IF NOT EXISTS `gcp-iceberg-dbt.analytics_source`
OPTIONS (location = "europe-west3");

-- Customers
CREATE OR REPLACE EXTERNAL TABLE `gcp-iceberg-dbt.analytics_source.customers_data`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://gcp-iceberg-dbt-raw/raw/commerce/customers/data/*.parquet']
);

-- Products
CREATE OR REPLACE EXTERNAL TABLE `gcp-iceberg-dbt.analytics_source.products_data`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://gcp-iceberg-dbt-raw/raw/commerce/products/data/*.parquet']
);

-- Orders
CREATE OR REPLACE EXTERNAL TABLE `gcp-iceberg-dbt.analytics_source.orders_data`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://gcp-iceberg-dbt-raw/raw/commerce/orders/data/*.parquet']
);

-- Order items
CREATE OR REPLACE EXTERNAL TABLE `gcp-iceberg-dbt.analytics_source.order_items_data`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://gcp-iceberg-dbt-raw/raw/commerce/order_items/data/*.parquet']
);

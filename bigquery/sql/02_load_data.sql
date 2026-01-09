-- ============================================
-- File: 02_load_data.sql
-- Purpose: Register Parquet files as Iceberg snapshots
-- Notes:
--   - No data is copied
--   - Each LOAD DATA creates a new snapshot
-- ============================================

-- Customers
LOAD DATA INTO `gcp-iceberg-dbt.analytics_iceberg.customers`
FROM FILES (
  format = 'PARQUET',
  uris = [
    'gs://gcp-iceberg-dbt-raw/raw/commerce/customers/load_date=2026-01-09/*.parquet'
  ]
);

-- Products
LOAD DATA INTO `gcp-iceberg-dbt.analytics_iceberg.products`
FROM FILES (
  format = 'PARQUET',
  uris = [
    'gs://gcp-iceberg-dbt-raw/raw/commerce/products/load_date=2026-01-09/*.parquet'
  ]
);

-- Orders
LOAD DATA INTO `gcp-iceberg-dbt.analytics_iceberg.orders`
FROM FILES (
  format = 'PARQUET',
  uris = [
    'gs://gcp-iceberg-dbt-raw/raw/commerce/orders/load_date=2026-01-09/*.parquet'
  ]
);

-- Order items
LOAD DATA INTO `gcp-iceberg-dbt.analytics_iceberg.order_items`
FROM FILES (
  format = 'PARQUET',
  uris = [
    'gs://gcp-iceberg-dbt-raw/raw/commerce/order_items/load_date=2026-01-09/*.parquet'
  ]
);

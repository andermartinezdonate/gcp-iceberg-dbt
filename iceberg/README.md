# Apache Iceberg (BigQuery-managed)

This project uses **Apache Iceberg** as the table format for analytical data
stored in **Google Cloud Storage (GCS)** and queried through **BigQuery**.

Iceberg provides a **metadata layer on top of Parquet files** that enables
reliable, scalable lakehouse-style analytics.

---

## Why Iceberg?

Iceberg adds capabilities that plain Parquet + external tables do not provide:

- Schema evolution (add / drop / rename columns safely)
- Snapshot-based versioning
- Time travel queries
- Atomic commits
- Safe incremental and append-only loads
- Engine interoperability (BigQuery, Spark, Trino, etc.)

---

## What Iceberg is (in this project)

In this setup:

- **Data files** live in GCS as Parquet  
- **Iceberg metadata** is managed by BigQuery  
- **BigQuery** uses Iceberg metadata to plan and execute queries  

Iceberg **does not store data itself**.  
It stores **metadata that references data files**.

---

## Iceberg table lifecycle

### 1. Create table (schema + storage)

Iceberg tables are created explicitly using BigQuery SQL.
This step defines:

- Table schema
- Iceberg table format
- Storage location in GCS
- Connection used to manage Iceberg metadata

**No data is loaded at this stage.**

Example:

'''sql
CREATE TABLE analytics_iceberg.orders (
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
);'''

After this step:

✅ Iceberg table exists

❌ No data is visible

❌ No snapshot exists

This is expected Iceberg behavior.


### 2. Create table (schema + storage)

Data becomes visible only after running LOAD DATA.

This operation:

Registers existing Parquet files

Creates a new Iceberg snapshot

Does not copy or move data

Is atomic

'''sql
LOAD DATA INTO analytics_iceberg.orders
FROM FILES (
  format = 'PARQUET',
  uris = ['gs://gcp-iceberg-dbt-raw/raw/commerce/orders/load_date=2026-01-09/*.parquet']
);'''

After this step:

✅ Snapshot is created

✅ Data becomes queryable

✅ Iceberg metadata references the files
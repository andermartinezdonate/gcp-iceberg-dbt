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

## Iceberg table lifecycle (BigQuery-managed, CTAS)

### 1. Create Iceberg table and load data (CTAS)

In this project, Iceberg tables are created using **BigQuery CTAS**
(**CREATE TABLE AS SELECT**).

This single step:

- Defines the table schema  
- Specifies the Iceberg table format  
- Specifies the storage location in GCS  
- Writes Parquet data files  
- Creates Iceberg metadata  

Example:

```sql
CREATE OR REPLACE TABLE analytics_iceberg.orders
WITH CONNECTION `europe-west3.iceberg_gcs`
OPTIONS (
  table_format = 'ICEBERG',
  file_format  = 'PARQUET',
  storage_uri  = 'gs://gcp-iceberg-dbt-iceberg/iceberg/commerce/orders/'
) AS
SELECT *
FROM analytics_source.orders_data;

What happens during this step:

- BigQuery reads raw Parquet via external tables
- BigQuery writes **new Parquet files** to the Iceberg location
- Iceberg metadata is written to GCS
- A consistent Iceberg table state is created

After this step:

- ✅ Iceberg table exists  
- ✅ Data is queryable  
- ✅ Iceberg metadata is present  
- ⚠️ Snapshot internals are managed by BigQuery  

---

## Notes on snapshots in BigQuery

When using BigQuery as the Iceberg engine:

- Snapshots are created as part of CTAS and write operations
- Iceberg metadata files are stored in GCS
- Snapshot inspection is **not fully exposed via SQL**
- Table versioning is still guaranteed by Iceberg semantics

This behavior differs from Spark / Trino Iceberg engines, where snapshots are directly queryable.

---

## Why `LOAD DATA` is not used in this project

This repository intentionally uses **CTAS only** to:

- Keep ingestion deterministic and reproducible
- Avoid multiple ingestion strategies
- Clearly separate:
  - **raw data access** (external tables)
  - **Iceberg table creation** (CTAS)

`LOAD DATA` is a valid Iceberg operation, but it is **out of scope** for this project.

---

## Summary

> In this project, BigQuery creates and manages Iceberg tables in GCS using CTAS, writing both data files and Iceberg metadata in a single step.

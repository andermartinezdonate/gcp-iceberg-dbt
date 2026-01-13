# gcp-iceberg-dbt

End-to-end **GCP lakehouse demo** using **Apache Iceberg**, **BigQuery**, and **dbt**.

This project demonstrates how to build a modern analytics stack on Google Cloud using an open table format (Iceberg) as the storage and versioning layer, BigQuery as the query engine, and dbt for analytics engineering.

---

## Architecture

**Flow**
Local / Scripted Data
↓
Google Cloud Storage (GCS)
↓
Apache Iceberg (table format, metadata, snapshots)
↓
BigQuery (query & analytics)
↓
dbt (staging → marts, tests)

**Key ideas**
- Iceberg handles **table format, schema evolution, and time travel**
- BigQuery queries Iceberg tables directly
- dbt builds clean analytical models on top

---

## Repository Structure
gcp-iceberg-dbt/
│
├── architecture/
│   └── architecture.md        # Lakehouse + Iceberg architecture explanation
│
├── bigquery/
│   └── sql/
│       ├── 01_external_tables.sql        # External tables over raw Parquet (read-only)
│       └── 02_create_iceberg_tables.sql  # CTAS → create Iceberg tables in GCS
│
├── iceberg/
│   └── README.md              # Iceberg concepts (metadata, snapshots, engines)
│
├── dbt/
│   ├── models/
│   │   ├── staging/
│   │   └── marts/
│   └── README.md              # dbt-on-Iceberg notes
│
├── data/
│   └── generated/             # Generated Parquet data (gitignored, reproducible)
│
├── scripts/
│   └── bootstrap_repo.sh      # Optional repo setup helpers
│
├── src/
│   └── generate_commerce_data_soft.py    # Parquet data generator
│
├── .gitignore
├── requirements.txt
└── README.md



---

## What This Project Shows

- How to organize data in **GCS** for Iceberg
- How to create and manage **Iceberg tables**
- How to query Iceberg tables from **BigQuery**
- How to build **dbt staging and mart models**
- How Iceberg snapshots differ from dbt snapshots
- Reproducible pipelines (no generated data committed)

---

## Prerequisites

- Google Cloud project
- GCS bucket
- BigQuery dataset
- Python 3.9+
- dbt (BigQuery adapter)
- Permissions to create tables and query data

---

## How to Run (High Level)
⚠️ BigQuery processing location must be set to `europe-west3` for all queries.


1. Configure GCP credentials
2. Upload raw data to GCS
3. Create Iceberg tables
4. Query tables from BigQuery
5. Run dbt models

Detailed, step-by-step instructions are provided in each folder.

---

## Why Iceberg + BigQuery + dbt?

- **Open format** (no vendor lock-in)
- **Time travel & schema evolution**
- **Separation of storage and compute**
- **Production-grade analytics workflows**

This mirrors real-world modern data platforms.

---


## Current State (Working)

- Source of truth: Parquet files in GCS (`raw/commerce/*/data`)
- Iceberg tables created in BigQuery:
  - analytics_iceberg.customers
  - analytics_iceberg.orders
  - analytics_iceberg.order_items
  - analytics_iceberg.products
- Iceberg storage location:
  gs://gcp-iceberg-dbt-iceberg/iceberg/commerce/*
- Created via BigQuery CTAS using Cloud Resource connection

---

## Author

Ander Martinez Donate  
Data Engineering / Analytics Engineering

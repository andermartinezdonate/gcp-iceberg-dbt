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
│       ├── 01_create_iceberg_tables.sql   # CREATE TABLE (Iceberg)
│       └── 02_load_data.sql               # LOAD DATA (Iceberg snapshots)
│
├── iceberg/
│   └── README.md               # Iceberg concepts: snapshots, time travel, notes
│
├── dbt/
│   ├── models/
│   │   ├── staging/
│   │   └── marts/
│   └── README.md               # dbt-on-Iceberg notes
│
├── data/
│   └── generated/              # Generated Parquet data (gitignored, reproducible)
│
├── scripts/
│   └── bootstrap_repo.sh       # Optional repo setup helpers
│
├── src/
│   └── generate_commerce_data_soft.py  # Parquet data generator
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

## Status

🚧 Work in progress  
Planned additions:
- Full GCS bootstrap scripts
- Iceberg snapshot/time-travel demos
- dbt tests and documentation


---

## Author

Ander Martinez Donate  
Data Engineering / Analytics Engineering

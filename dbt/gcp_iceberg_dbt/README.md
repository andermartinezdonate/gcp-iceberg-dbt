# dbt Analytics Layer (Iceberg + BigQuery)

This directory contains the **analytics modeling layer** built with **dbt** on top of
**Apache Iceberg tables queried through BigQuery**.

The focus of this layer is to transform raw Iceberg-backed data into
**tested, analytics-ready fact and dimension tables**.

---

## Model Structure

'''text
models/
├── staging/
│   ├── stg_orders.sql
│   ├── stg_order_items.sql
│   └── stg_products.sql
└── marts/
    ├── fct_order_items.sql
    ├── fct_orders.sql
    ├── fct_orders_enriched.sql
    ├── dim_customers.sql
    ├── dim_products.sql
    └── schema.yml'''


## Analytics Design

The modeling approach follows a **fact + dimension** pattern with a clear separation
between **scalable ingestion logic** and **history-dependent business logic**.

### Fact tables

- **fct_order_items**  
  Order-item grain (one row per product per order).

- **fct_orders** *(incremental)*  
  Order-level fact table optimized for scale using BigQuery `MERGE`.  
  Contains only ingestion-safe fields and supports incremental loading.

- **fct_orders_enriched**  
  Semantic order fact derived from `fct_orders`.  
  Computes history-dependent logic such as:
  - `is_first_order`

### Dimension tables

- **dim_customers**  
  One row per customer, built from enriched order facts.

- **dim_products**  
  One row per product with descriptive attributes.
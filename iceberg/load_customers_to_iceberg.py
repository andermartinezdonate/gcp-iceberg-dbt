import pyarrow.parquet as pq
import pyarrow as pa
import pandas as pd

from pyiceberg.catalog import load_catalog
from pyiceberg.schema import Schema
from pyiceberg.types import (
    StringType, BooleanType, TimestampType
)
from pyiceberg.partitioning import PartitionSpec
from pyiceberg.table.sorting import SortOrder

RAW_PARQUET = "gs://gcp-iceberg-dbt-raw/raw/commerce/customers/load_date=2026-01-09/customers.parquet"
ICEBERG_WAREHOUSE = "gs://gcp-iceberg-dbt-iceberg/warehouse"
NAMESPACE = "commerce"
TABLE = "customers"

def main():
    # 1) Read raw parquet schema (arrow)
    raw_table = pq.read_table(RAW_PARQUET)
    raw_schema = raw_table.schema

    # 2) Define an Iceberg schema explicitly (minimal + safe)
    #    Adjust field ids if you later evolve schema; for now keep stable IDs.
    iceberg_schema = Schema(
        # required=False everywhere to keep it simple
        pa.field("customer_id", pa.string(), nullable=True).metadata,
    )

if __name__ == "__main__":
    main()

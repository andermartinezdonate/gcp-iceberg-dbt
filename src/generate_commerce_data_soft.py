# File: src/generate_commerce_data_soft.py
# Requirements: pip install pandas pyarrow
from pathlib import Path
import pandas as pd
from datetime import timedelta
import random
import uuid
import pyarrow as pa
import pyarrow.parquet as pq

# -------- config --------
LOAD_DATE = "2026-01-09"  # partition folder name
OUT_BASE = Path("data/generated/commerce")
random.seed(42)

# Use pandas UTC timestamp but store as tz-naive microseconds for BigQuery compatibility
now = pd.Timestamp.utcnow().floor("us")  # tz-naive, microsecond precision

N_CUSTOMERS = 200
N_PRODUCTS = 80
N_ORDERS = 600
MAX_ITEMS_PER_ORDER = 4
CURRENCY = "EUR"
SOURCE_SYSTEM = "demo_commerce"
CITIES = ["Madrid", "Barcelona", "Valencia", "Sevilla", "Granada"]

def out_dir(table: str) -> Path:
    d = OUT_BASE / table / f"load_date={LOAD_DATE}"
    d.mkdir(parents=True, exist_ok=True)
    return d

def _force_datetime_us_tznaive(s: pd.Series) -> pd.Series:
    # Convert to UTC, drop timezone, force microseconds
    # Handles tz-aware and tz-naive inputs safely.
    dt = pd.to_datetime(s, utc=True, errors="coerce")
    dt = dt.dt.tz_convert("UTC").dt.tz_localize(None)
    return dt.astype("datetime64[us]")

def to_parquet_us(df: pd.DataFrame, path: Path) -> None:
    """
    Force all datetime columns to Parquet TIMESTAMP_MICROS (timestamp[us]) and tz-naive.
    This avoids BigQuery's TIMESTAMP_NANOS load error.
    """
    df = df.copy()

    # normalize pandas dtypes
    for col in df.columns:
        if pd.api.types.is_datetime64_any_dtype(df[col]) or df[col].dtype == "object":
            # only attempt if it looks like datetime values
            if col.endswith("_at") or col.endswith("_ts") or col in ("created_at", "updated_at", "ingested_at", "order_ts"):
                try:
                    df[col] = _force_datetime_us_tznaive(df[col])
                except Exception:
                    pass

    # build arrow table
    table = pa.Table.from_pandas(df, preserve_index=False)

    # force any timestamp columns to timestamp('us')
    new_fields = []
    for field in table.schema:
        if pa.types.is_timestamp(field.type):
            new_fields.append(pa.field(field.name, pa.timestamp("us"), nullable=True))
        else:
            new_fields.append(field)
    target_schema = pa.schema(new_fields)

    table = table.cast(target_schema)

    pq.write_table(
        table,
        path,
        compression="snappy",
        use_dictionary=True,
        coerce_timestamps="us",
        allow_truncated_timestamps=True,
    )

# -------- customers --------
customers = []
for i in range(N_CUSTOMERS):
    created_at = now - pd.Timedelta(days=random.randint(30, 365))
    updated_at = created_at + pd.Timedelta(days=random.randint(0, 60))
    customers.append({
        "customer_id": str(uuid.uuid4()),
        "email": f"user{i}@example.com",
        "country": "ES",
        "city": random.choice(CITIES),
        "created_at": created_at,
        "updated_at": updated_at,
        "is_active": random.random() > 0.05,
        "source_system": SOURCE_SYSTEM,
        "ingested_at": now,
    })

df_customers = pd.DataFrame(customers)
to_parquet_us(df_customers, out_dir("customers") / "customers.parquet")

# -------- products --------
products = []
for i in range(N_PRODUCTS):
    products.append({
        "product_id": str(uuid.uuid4()),
        "sku": f"SKU-{100000+i}",
        "product_name": f"Product {i}",
        "category": random.choice(["electronics", "apparel", "home", "beauty", "sports"]),
        "brand": random.choice(["acme", "globex", "initech"]),
        "unit_price": round(random.uniform(5, 200), 2),
        "currency": CURRENCY,
        "is_active": random.random() > 0.03,
        "ingested_at": now,
    })

df_products = pd.DataFrame(products)
to_parquet_us(df_products, out_dir("products") / "products.parquet")

# -------- orders + order_items --------
orders = []
order_items = []

for _ in range(N_ORDERS):
    order_id = str(uuid.uuid4())
    customer = random.choice(customers)

    order_ts = now - pd.Timedelta(
        days=random.randint(1, 90),
        hours=random.randint(0, 23),
        minutes=random.randint(0, 59),
    )

    order_status = random.choices(
        ["CREATED", "PAID", "CANCELLED"],
        weights=[0.10, 0.85, 0.05],
        k=1
    )[0]

    payment_status = (
        "CAPTURED" if order_status == "PAID"
        else ("VOIDED" if order_status == "CANCELLED" else "PENDING")
    )

    n_items = random.randint(1, MAX_ITEMS_PER_ORDER)
    total_amount = 0.0

    for line in range(1, n_items + 1):
        product = random.choice(products)
        qty = random.randint(1, 3)
        line_total = round(qty * product["unit_price"], 2)
        total_amount += line_total

        order_items.append({
            "order_item_id": str(uuid.uuid4()),
            "order_id": order_id,
            "product_id": product["product_id"],
            "quantity": qty,
            "unit_price": product["unit_price"],
            "currency": CURRENCY,
            "line_total_amount": line_total,
            "item_status": "FULFILLED" if order_status == "PAID" else order_status,
            "ingested_at": now,
        })

    orders.append({
        "order_id": order_id,
        "customer_id": customer["customer_id"],
        "order_ts": order_ts,
        "order_status": order_status,
        "currency": CURRENCY,
        "total_amount": round(total_amount, 2),
        "payment_status": payment_status,
        "source_system": SOURCE_SYSTEM,
        "ingested_at": now,
    })

df_orders = pd.DataFrame(orders)
df_order_items = pd.DataFrame(order_items)

to_parquet_us(df_orders, out_dir("orders") / "orders.parquet")
to_parquet_us(df_order_items, out_dir("order_items") / "order_items.parquet")

print("Wrote Parquet files under:", OUT_BASE)

from pathlib import Path
import pandas as pd
from datetime import datetime, timedelta
import random
import uuid

OUT_DIR = Path("data/generated")
OUT_DIR.mkdir(parents=True, exist_ok=True)

random.seed(42)
now = datetime.utcnow()

# Customers
customers = []
for i in range(10):
    customers.append({
        "customer_id": str(uuid.uuid4()),
        "email": f"user{i}@example.com",
        "full_name": f"Customer {i}",
        "country": "ES",
        "city": random.choice(["Madrid", "Barcelona", "Valencia"]),
        "created_at": now - timedelta(days=30),
        "updated_at": now,
    })
df_customers = pd.DataFrame(customers)
df_customers.to_parquet(OUT_DIR / "customers.parquet", index=False)

# Products
products = []
for i in range(5):
    products.append({
        "product_id": str(uuid.uuid4()),
        "sku": f"SKU-{1000+i}",
        "product_name": f"Product {i}",
        "category": "general",
        "unit_price": round(random.uniform(10, 100), 2),
        "is_active": True,
        "updated_at": now,
    })
df_products = pd.DataFrame(products)
df_products.to_parquet(OUT_DIR / "products.parquet", index=False)

# Orders + Order Items
orders = []
order_items = []

for i in range(15):
    order_id = str(uuid.uuid4())
    customer = random.choice(customers)
    order_ts = now - timedelta(days=random.randint(1, 10))

    orders.append({
        "order_id": order_id,
        "customer_id": customer["customer_id"],
        "order_ts": order_ts,
        "order_date": order_ts.date(),
        "status": "PAID",
        "payment_method": "CARD",
        "shipping_country": "ES",
        "shipping_city": customer["city"],
        "updated_at": now,
    })

    for line in range(random.randint(1, 3)):
        product = random.choice(products)
        qty = random.randint(1, 3)

        order_items.append({
            "order_id": order_id,
            "line_id": line + 1,
            "product_id": product["product_id"],
            "quantity": qty,
            "unit_price": product["unit_price"],
            "line_total": round(qty * product["unit_price"], 2),
            "updated_at": now,
        })

df_orders = pd.DataFrame(orders)
df_order_items = pd.DataFrame(order_items)

df_orders.to_parquet(OUT_DIR / "orders.parquet", index=False)
df_order_items.to_parquet(OUT_DIR / "order_items.parquet", index=False)

print("Wrote Parquet files to data/generated/")

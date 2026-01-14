select
  order_id,
  customer_id,
  order_ts,
  order_status,
  currency,
  total_amount,
  payment_status,
  source_system,
  ingested_at
from {{ source('iceberg', 'orders') }}

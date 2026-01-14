select
  order_item_id,
  order_id,
  product_id,
  quantity,
  unit_price,
  currency,
  line_total_amount,
  item_status,
  ingested_at
from {{ source('iceberg', 'order_items') }}

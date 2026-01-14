select
  product_id,
  sku,
  product_name,
  category,
  brand,
  unit_price,
  currency,
  is_active,
  ingested_at
from {{ source('iceberg', 'products') }}


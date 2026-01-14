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
from (
  select
    product_id,
    sku,
    product_name,
    category,
    brand,
    unit_price,
    currency,
    is_active,
    ingested_at,
    row_number() over (
      partition by product_id
      order by ingested_at desc
    ) as rn
  from {{ source('iceberg', 'products') }}
)
where rn = 1

select
  customer_id,
  email,
  country,
  city,
  created_at,
  updated_at,
  is_active,
  source_system,
  ingested_at
from {{ source('iceberg', 'customers') }}

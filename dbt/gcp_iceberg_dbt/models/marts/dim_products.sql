{{ config(materialized='table') }}

select
    product_id,
    product_name,
    category,
    brand,
    sku,
    unit_price as price,   -- or keep as unit_price
    currency,
    is_active
from {{ ref('stg_products') }}
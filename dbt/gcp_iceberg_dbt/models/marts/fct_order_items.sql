{{ config(materialized='table') }}

select
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price as line_amount

from {{ ref('stg_order_items') }} oi

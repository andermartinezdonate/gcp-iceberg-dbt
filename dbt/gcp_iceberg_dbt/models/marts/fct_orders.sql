{{ config(materialized='table') }}

with order_items as (
    select
        order_id,
        count(*) as items_count,
        sum(line_amount) as order_amount
    from {{ ref('fct_order_items') }}
    group by 1
),

orders as (
    select
        s.order_id,
        s.customer_id,
        date(s.order_ts) as order_date
    from {{ ref('stg_orders') }} s
),

orders_enriched as (
    select
        o.order_id,
        o.customer_id,
        o.order_date,
        coalesce(oi.items_count, 0) as items_count,
        coalesce(oi.order_amount, 0) as order_amount
    from orders o
    left join order_items oi
      on o.order_id = oi.order_id
),

first_order as (
    select
        customer_id,
        min(order_date) as first_order_date
    from orders
    group by 1
)

select
    oe.*,
    (oe.order_date = fo.first_order_date) as is_first_order
from orders_enriched oe
left join first_order fo
  on oe.customer_id = fo.customer_id
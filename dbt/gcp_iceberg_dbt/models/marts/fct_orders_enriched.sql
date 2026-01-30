{{ config(materialized='table') }}

with base as (
  select * from {{ ref('fct_orders') }}
),

first_order as (
  select
    customer_id,
    min(order_date) as first_order_date
  from base
  group by 1
)

select
  b.order_id,
  b.customer_id,
  b.order_date,
  b.items_count,
  b.order_amount,
  (b.order_date = fo.first_order_date) as is_first_order
from base b
left join first_order fo
  on b.customer_id = fo.customer_id
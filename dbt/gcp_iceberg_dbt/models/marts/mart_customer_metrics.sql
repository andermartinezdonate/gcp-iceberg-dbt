{{ config(materialized='table') }}

with customers as (
  select customer_id
  from {{ ref('dim_customers') }}
),

orders as (
  select
    customer_id,
    order_date,
    order_amount
  from {{ ref('fct_orders_enriched') }}
),

customer_base as (
  select
    customer_id,
    min(order_date) as first_order_date,
    max(order_date) as last_order_date,
    count(*) as total_orders,
    sum(order_amount) as lifetime_revenue,
    avg(order_amount) as avg_order_value
  from orders
  group by 1
),

customer_recency as (
  select
    customer_id,
    date_diff(current_date(), max(order_date), day) as days_since_last_order
  from orders
  group by 1
),

customer_ordering_behavior as (
  select
    customer_id,
    avg(date_diff(order_date, prev_order_date, day)) as avg_days_between_orders
  from (
    select
      customer_id,
      order_date,
      lag(order_date) over (partition by customer_id order by order_date) as prev_order_date
    from orders
  )
  where prev_order_date is not null
  group by 1
)

select
  c.customer_id,

  cb.first_order_date,
  cb.last_order_date,
  cb.total_orders,
  cb.lifetime_revenue,
  cb.avg_order_value,

  cr.days_since_last_order,
  (cr.days_since_last_order <= 30) as is_active_last_30d,

  cob.avg_days_between_orders,

  (cb.total_orders > 1) as is_repeat_customer,

  case
    when cb.lifetime_revenue >= 500 then 'high_value'
    when cb.lifetime_revenue >= 200 then 'mid_value'
    else 'low_value'
  end as customer_segment
from customers c
left join customer_base cb using (customer_id)
left join customer_recency cr using (customer_id)
left join customer_ordering_behavior cob using (customer_id)
{{ config(materialized='table') }}

select
    customer_id,

    min(order_date) as first_order_date,
    max(order_date) as last_order_date,

    count(order_id) as total_orders,
    sum(order_amount) as total_revenue,
    avg(order_amount) as avg_order_value,

    count(order_id) > 1 as is_repeat_customer

from {{ ref('fct_orders') }}
group by customer_id
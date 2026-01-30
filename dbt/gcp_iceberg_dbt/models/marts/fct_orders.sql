{{ config(
    materialized='incremental',
    unique_key='order_id',
    incremental_strategy='merge'
) }}

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
        date(s.order_ts) as order_date,
        s.ingested_at
    from {{ ref('stg_orders') }} s
    {% if is_incremental() %}
      where s.ingested_at > (
        select coalesce(max(ingested_at), timestamp('1970-01-01'))
        from {{ this }}
      )
    {% endif %}
)

select
    o.order_id,
    o.customer_id,
    o.order_date,
    coalesce(oi.items_count, 0) as items_count,
    coalesce(oi.order_amount, 0) as order_amount,
    o.ingested_at
from orders o
left join order_items oi
  on o.order_id = oi.order_id
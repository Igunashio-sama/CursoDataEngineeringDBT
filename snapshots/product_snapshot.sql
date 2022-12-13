{% snapshot product_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='product_id',
      strategy='timestamp',
      updated_at='date_load',
      invalidate_hard_deletes=True
        )
}}

select * from {{ ref('dim_products') }}

{% endsnapshot %}
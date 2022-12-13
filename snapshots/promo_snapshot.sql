{% snapshot promo_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='promo_id',
      strategy='timestamp',
      updated_at='date_load',
      invalidate_hard_deletes=True
        )
}}

select * from {{ ref('dim_promos') }}

{% endsnapshot %}
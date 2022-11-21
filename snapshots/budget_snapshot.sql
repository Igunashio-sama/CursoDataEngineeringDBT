{% snapshot budget_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='_row',
      strategy='check',
      check_cols=['quantity'],
      invalidate_hard_deletes=True
        )
}}

select * from {{ source('google_sheets', 'budget') }}

{% endsnapshot %}
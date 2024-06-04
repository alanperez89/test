WITH data_staging_bank_marketing AS (
    SELECT * FROM {{ref('staging_bank_marketing')}} --importar raw data
),

data_contact AS (
    SELECT * FROM {{ref('dim_contact_detail')}} -- importar dim_contact_detail
),

data_customer AS (
    SELECT * FROM {{ref('dim_customer_profile')}} -- importar dim_customer_profile
),

data_transform AS (
   SELECT
    survey_id
    age,
    balance
    , campaign
    , case when education='primary' then 1
    when education='secondary' then 2
    else 0 end as education
    , case when mark.housing=true then 1 else 0 end as housing
    , case when loan = true then 1 else 0 end as loan
    , sub
  FROM data_staging_bank_marketing mark
  JOIN data_contact prof ON prof.contact_details_id = mark.contact_details_id
  JOIN data_customer det ON det.customer_profile_id = mark.customer_profile_id
)
 
select * from data_transform
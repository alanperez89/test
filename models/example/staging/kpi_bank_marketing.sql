WITH data_staging_bank_marketing AS (
    SELECT * FROM {{ref('staging_bank_marketing')}} --importar raw data
),

data_customer AS (
    SELECT * FROM {{ref('dim_customer_profile')}} -- importar dim_customer_profile
),

customer_data AS (                    -- construir tabla con info relevante para la segmentacion
  SELECT
    m.customer_profile_id,
    age,
    balance,
    housing,
    poutcome,
    sub
  FROM data_staging_bank_marketing m
  JOIN data_customer p ON m.customer_profile_id = p.customer_profile_id
),

percentile_data AS (                                             -- crear segmentacion
  SELECT
    customer_profile_id,
    PERCENTILE_CONT(age, 0.25) OVER () AS age_25th,
    PERCENTILE_CONT(age, 0.50) OVER () AS age_50th,
    PERCENTILE_CONT(age, 0.75) OVER () AS age_75th,
    PERCENTILE_CONT(balance, 0.25) OVER () AS balance_25th,
    PERCENTILE_CONT(balance, 0.50) OVER () AS balance_50th,
    PERCENTILE_CONT(balance, 0.75) OVER () AS balance_75th
  FROM customer_data limit 1
),

cluster_data as (                                                                  -- crear grupos
SELECT
  customer_profile_id
  ,case when housing = true then 'Homeowner' else 'Renter'end as housing
  ,poutcome
  ,sub
  ,CASE
    WHEN age < (select age_25th from percentile_data) AND balance < (select balance_25th from percentile_data) THEN 'Young and Low Balance'
    WHEN age < (select age_25th from percentile_data) AND balance >= (select balance_25th from percentile_data) THEN 'Young and High Balance'
    WHEN age BETWEEN (select age_25th from percentile_data) AND (select age_75th from percentile_data) AND balance < (select balance_25th from percentile_data) THEN 'Middle-Aged and Low Balance'
    WHEN age BETWEEN (select age_25th from percentile_data) AND (select age_75th from percentile_data) AND balance >= (select age_25th from percentile_data) THEN 'Middle-Aged and High Balance'
    WHEN age > (select age_75th from percentile_data) AND balance < (select balance_25th from percentile_data) THEN 'Senior and Low Balance'
    WHEN age > (select age_75th from percentile_data) AND balance >= (select balance_25th from percentile_data) THEN 'Senior and High Balance'
  END AS client_segment
FROM customer_data where poutcome!='unknown'
),

final as (select                                 -- agrupacion y conteo
client_segment
,housing 
,COUNTIF(sub = true) as success_count
,(COUNTIF(sub = true) / COUNT(*)) * 100 AS conversion_rate 
from cluster_data
group by  client_segment,housing)

select * from final          -- select final
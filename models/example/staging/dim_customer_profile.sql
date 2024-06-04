WITH data_raw AS (
    SELECT * FROM {{ref('raw_bank_marketing')}}
),

data_transform AS (
    SELECT
        DISTINCT job,
        marital,
        education,
        poutcome,
        y
    FROM
        data_raw
    WHERE
     y IS NOT NULL
),

final AS (
    SELECT
        GENERATE_UUID() as customer_profile_id,
        * 
    FROM 
        data_transform 
)

SELECT * FROM final



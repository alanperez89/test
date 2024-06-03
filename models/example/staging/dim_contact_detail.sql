WITH data_raw AS (
    SELECT * FROM {{ref('raw_bank_marketing')}}
),

data_transform AS (
    SELECT
        DISTINCT contact,
        month,
        day
    FROM
        data_raw
),

final AS (
    SELECT
        GENERATE_UUID() as contact_details_id,
        * 
    FROM 
        data_transform 
)

SELECT * FROM final 
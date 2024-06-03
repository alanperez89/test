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
    WHERE day BETWEEN 1 AND 31
),

final AS (
    SELECT
        GENERATE_UUID() as contact_details_id,
        * 
    FROM 
        data_transform 
)

SELECT * FROM final 
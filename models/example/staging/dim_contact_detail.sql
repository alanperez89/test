WITH data_raw AS (
    SELECT * FROM {{ref('raw_bank_marketing')}}   -- se importa la raw data
),

data_transform AS (          -- se construye la tabla dim_contact_detail
    SELECT
        DISTINCT contact,
        month,
        day
    FROM
        data_raw
),

final AS (                                -- se genera una PK
    SELECT
        GENERATE_UUID() as contact_details_id,
        * 
    FROM 
        data_transform 
)

SELECT * FROM final           -- select final
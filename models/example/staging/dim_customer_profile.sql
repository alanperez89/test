WITH data_raw AS (
    SELECT * FROM {{ref('raw_bank_marketing')}}   -- se importa la raw data
),

data_transform AS (      -- se construye la tabla dim_customer_profile y se filtra el resultado de la encuesta (conversion) y los unknown
    SELECT
        DISTINCT job,
        marital,
        education,
        poutcome,
        y AS sub
    FROM
        data_raw
    WHERE
     y IS NOT NULL
     AND education != 'unknown'
     AND poutcome != 'unknown'
),

final AS (                                               -- se genera un PK
    SELECT
        GENERATE_UUID() as customer_profile_id,
        * 
    FROM 
        data_transform 
)

SELECT * FROM final         -- select final 



WITH raw_data AS (
    Select * 
    FROM Rawdata.raw_bank_marketing
),

final as (
    SELECT * 
    FROM raw_data)

SELECT * FROM final
    

    





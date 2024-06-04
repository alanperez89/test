WITH data_raw AS (
    SELECT * FROM {{ref('raw_bank_marketing')}} --importar raw data
),

data_contact AS (
    SELECT * FROM {{ref('dim_contact_detail')}} -- importar dim_contact_detail
),

data_customer AS (
    SELECT * FROM {{ref('dim_customer_profile')}} -- importar dim_customer_profile
),

data_transform AS (                               -- se construye la tabla staging_bank_marketing
    SELECT
        contact.contact_details_id,
        customer.customer_profile_id,
        raw.age,
        raw.default,
        raw.balance,
        raw.housing,
        raw.loan,
        raw.duration,
        raw.campaign,
        raw.pdays,
        raw.previous
        
    FROM
        data_raw as raw
        LEFT JOIN data_contact as contact ON contact.contact = raw.contact AND contact.month = raw.month AND contact.day = raw.day
        LEFT JOIN data_customer as customer ON customer.job = raw.job AND customer.marital = raw.marital AND customer.education = raw.education AND customer.poutcome = raw.poutcome
),

final AS (                                      -- se agrega una PK
    SELECT
        GENERATE_UUID() as survey_id,
        * 
    FROM 
        data_transform
)

SELECT * FROM final                         -- select final
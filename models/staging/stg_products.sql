-- Extraemos el catálogo de productos crudo desde BigQuery
WITH source_products AS (
    SELECT * FROM {{ source('ecom_raw', 'products') }}
),
-- Como todo viene limpio y con los tipos correctos lo pasamos asi
cleaned_products AS (
    SELECT
        product_id, -- ID de producto
        name AS product_name, -- Se cambia product_name para ser mas especifico
        price -- Ya viene como float, no se hace nada
    FROM source_products
)
-- Entregamos el catálogo
SELECT 
    product_id,
    product_name,
    price
FROM cleaned_products
-- Extraemos los items limpios y el catálogo de productos
WITH order_items AS (
    SELECT * FROM {{ ref('stg_order_items') }}
),
products AS (
    SELECT * FROM {{ ref('stg_products') }}
),
-- Cruzamos directo para traer el precio y sacar el total de la línea
items_products AS (
    SELECT
        i.order_id,
        i.product_id,
        i.quantity,        
        -- Si un producto no existe en el catálogo, le ponemos 0 al precio
        COALESCE(p.price, 0) AS unit_price,  
        -- Multiplicamos cantidad por precio (si hay devoluciones en negativo, el total queda en negativo)
        (i.quantity * COALESCE(p.price, 0)) AS total_revenue   
    FROM order_items i
    LEFT JOIN products p 
        ON i.product_id = p.product_id
)
SELECT * FROM items_products
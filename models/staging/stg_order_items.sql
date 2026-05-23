-- Extraccion de la cantidad de artículos por orden desde BigQuery
WITH source_order_items AS (
    SELECT * FROM {{ source('ecom_raw', 'order_items') }}
),
-- Extraemos la tabla
cleaned_order_items AS (
    SELECT
        order_id,   -- ID de la orden (se repite 1 pero puede que sean productos distintos en la misma orden)
        product_id, -- ID del producto(el producto inexistente se elimina en la capa de intermediate)
        quantity    -- Cantidad de productos por orden, respetamos los negativos ya que podrian ser devoluciones    
    FROM source_order_items
)
-- Entregamos la tabla limpia
SELECT 
    order_id,
    product_id,
    quantity
FROM cleaned_order_items
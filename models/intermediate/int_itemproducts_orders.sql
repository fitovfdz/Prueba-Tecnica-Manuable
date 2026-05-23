-- Extraemos los datos limpios de las órdenes
WITH orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),
-- Traemos el detalle de los productos y sus precios calculados en el modelo anterior
items AS (
    SELECT * FROM {{ ref('int_items_products') }}
),
-- Unimos ambas tablas 
orders_joined AS (
    SELECT
        -- Datos generales de la orden y del cliente (vienen de la tabla orders)
        o.order_id,
        o.customer_id,
        o.order_date,
        o.status,   
        -- Datos específicos del producto vendido en esa orden (vienen de la tabla items), si no se encuentra una orden, entonces se cambia de null a 0
        coalesce(i.product_id, 'Sin Producto') as product_id,
        coalesce(i.quantity, 0) as quantity,
        coalesce(i.unit_price, 0) as unit_price,
        coalesce(i.total_revenue, 0) as total_revenue      
    FROM orders o
    -- Usamos LEFT JOIN para que siempre aparezcan las órdenes, incluso si hubo un error y no tienen productos
    LEFT JOIN items i 
        ON o.order_id = i.order_id
)
-- Entregamos el resultado final
SELECT * FROM orders_joined
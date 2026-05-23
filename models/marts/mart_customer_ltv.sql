-- extraemos el catálogo completo de clientes desde Staging
WITH customers AS (
    SELECT 
        customer_id,
        name,
        email
    FROM {{ ref('stg_customers') }}
),

-- 2. Agrupamos las órdenes de la capa Marts para obtener el histórico por cliente
customer_orders AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_order_date,
        MAX(order_date) AS last_order_date,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(total_revenue) AS total_revenue
    FROM {{ ref('mart_orders_summary') }}
    GROUP BY customer_id
)

-- Unimos todo asegurando que aparezcan todos los clientes del catálogo
SELECT
    c.customer_id,
    c.name,
    c.email,
    co.first_order_date,
    co.last_order_date,
    
    -- Si un cliente no tiene órdenes, aseguramos que muestre 0 en lugar de NULL
    COALESCE(co.total_orders, 0) AS total_orders,
    COALESCE(co.total_revenue, 0) AS total_revenue,
    
    -- Calculo de tipo de cliente
    CASE 
        WHEN COALESCE(co.total_orders, 0) < 2 THEN 'Nuevo'
        WHEN co.total_revenue > 5000 THEN 'VIP'
        WHEN co.total_revenue > 500 THEN 'Regular'
        ELSE 'Regular' 
    END AS customer_type

FROM customers c
LEFT JOIN customer_orders co 
    ON c.customer_id = co.customer_id
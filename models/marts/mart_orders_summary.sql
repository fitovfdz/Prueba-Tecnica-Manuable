--  Extraemos la información detallada de tu modelo intermedio
WITH intermediate_data AS (
    SELECT * FROM {{ ref('int_itemproducts_orders') }}
)
--  Agrupamos por orden para obtener los totales
SELECT
    order_id,
    customer_id,
    order_date,    
    -- Sumamos las métricas
    SUM(quantity) AS total_items,
    SUM(total_revenue) AS total_revenue,    
    -- Renombramos la columna, porque ya viene limpia y en minúsculas desde staging
    status AS order_status
FROM intermediate_data
GROUP BY
    order_id,
    customer_id,
    order_date,
    status
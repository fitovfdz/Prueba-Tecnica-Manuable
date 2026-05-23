-- Traemos las órdenes crudas desde el source de BigQuery
WITH source_orders AS (
    SELECT * FROM {{ source('ecom_raw', 'orders') }}
),
-- Aquí quitamos los duplicados y limpiamos los formatos
cleaned_orders AS (
    SELECT DISTINCT -- Con el DISTINCT quitamos los order_id duplicados
        order_id, -- ID de la orden
        customer_id, -- ID del cliente (el cliente inexistente se quita en la capa intermediate)
        CAST(order_date AS DATE) AS order_date, -- Lo pasamos a tipo DATE y si viene nulo se mantiene NULL limpio ya que es formato fecha
        {{ clean_text('status') }} AS status -- SE UTILIZA LA MACRO PARA BORRAR ESPACIOS Y CAMBIAR A MINUSCULAS
    FROM source_orders
)
-- Entregamos las órdenes limpias y listas para el modelo
SELECT 
    order_id,
    customer_id,
    order_date,
    status
FROM cleaned_orders
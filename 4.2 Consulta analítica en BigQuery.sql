WITH monthly_sales AS (
  -- Paso 1: Agrupamos las ventas por mes y producto.
  -- Usamos DATE_TRUNC para normalizar todas las fechas al primer día del mes.
  SELECT 
    -- Convertimos la fecha completa (ej. 2024-02-10) al primer día del mes (2024-02-01).
    -- Esto nos permite agrupar todas las ventas de un mismo mes bajo una sola etiqueta.
    DATE_TRUNC(DATE(o.order_date), MONTH) AS sale_month, 
    p.name AS product_name,
    SUM(p.price * oi.quantity) AS monthly_revenue
  FROM `pruebatecnica-manuable.raw.orders` o
  JOIN `pruebatecnica-manuable.raw.order_items` oi ON o.order_id = oi.order_id
  JOIN `pruebatecnica-manuable.raw.products` p ON oi.product_id = p.product_id
  
  -- Filtramos dinámicamente los últimos 3 meses basándonos en la fecha más reciente 
  -- encontrada en la tabla.
  WHERE DATE(o.order_date) >= DATE_SUB((SELECT DATE(MAX(order_date)) FROM `pruebatecnica-manuable.raw.orders`), INTERVAL 3 MONTH)
  
    GROUP BY 1, 2
  ),

ranked_sales AS (
  -- Paso 2: Calculamos métricas comparativas.
  -- Usamos LAG para traer el revenue del mes anterior y comparar el desempeño.
  -- Usamos DENSE_RANK para listar los productos más vendidos de cada mes.
  SELECT *,
  -- Usamos LAG para obtener el ingreso del mes anterior para el mismo producto.
  -- PARTITION BY asegura que el cálculo sea solo por producto y ORDER BY lo ordena cronológicamente.
    LAG(monthly_revenue) OVER(PARTITION BY product_name ORDER BY sale_month) AS prev_month_revenue,
  -- DENSE_RANK asigna un lugar en el ranking según los ingresos mensuales.
  -- PARTITION BY sale_month hace que el ranking se calcule de forma independiente para cada mes.
  -- Usamos DENSE_RANK en lugar de RANK para evitar saltos en la numeración si hay empates.
    DENSE_RANK() OVER(PARTITION BY sale_month ORDER BY monthly_revenue DESC) AS rank
  FROM monthly_sales
)

-- Paso 3: Obtenemos el reporte final.
-- Filtramos solo el Top 5 de cada mes y calculamos el porcentaje de variación.
-- Usamos SAFE_DIVIDE para evitar errores matemáticos si no hay datos previos.
SELECT 
  sale_month,
  product_name,
  monthly_revenue,
  SAFE_DIVIDE((monthly_revenue - prev_month_revenue), prev_month_revenue) * 100 AS percentage_variance
FROM ranked_sales
WHERE rank <= 5
ORDER BY sale_month DESC, rank ASC
--- NOTA: Deje el dato de -1200 en negativo porque puede ser una devolucion y se tiene que registrar la perdida, pero habria que revisar con el area operativa para validar si realmente es devolucion o un error de signo
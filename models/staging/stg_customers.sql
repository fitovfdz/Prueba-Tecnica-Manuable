-- Extraccion de datos crudos desde BigQuery usando la macro de dbt
WITH source_customers AS (
    SELECT * FROM {{ source('ecom_raw', 'customers') }}
),
-- Limpiamos y estandarizamos la tabla
cleaned_customers AS (
    SELECT
        customer_id, --ID del cliente
        coalesce(name,'Sin Nombre') as name, --Reemplazamos datos null
       {{ clean_text('email') }} as email -- SE UTILIZA LA MACRO CREADA PARA BORRAR ESPACIOS Y CAMBIAR A MINUSCULAS
    FROM source_customers
)
-- Entregamos la tabla limpia y lista para usar
SELECT 
    customer_id,
    name,
    email
FROM cleaned_customers
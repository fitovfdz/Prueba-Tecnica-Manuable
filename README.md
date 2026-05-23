# Prueba Técnica Manuable

Hola, Este repositorio contiene la solución completa para la prueba técnica. Aquí documenté el proceso de transformación de datos, la lógica aplicada y la estructura que desarrollé.

## Estructura del proyecto
* **Transformaciones en dbt (models)**: Aquí están los modelos del proyecto. Se crearon las capas solicitadas staging > intermediate > marts con sus respectivos modelos
* **Macros**: Macro para normalizar texto
* **Test** : Tests genericos en schema.yml y test singular personalizado
* **4.2 Consulta analítica en BigQuery.sql**: La query específica solicitada del punto 4.2.
* **Orquestacion Airflow.txt**: Una propuesta clara de cómo automatizaría este pipeline usando Airflow.
* **Lineage Graph.png**: Un visual de cómo fluyen los datos a través de los modelos.
* **3.2 Pregunta teórica.txt**: Mis respuestas a los puntos conceptuales que solicitaron.

## Instrucciones para revisar este proyecto
* **Este proyecto fue desarrollado utilizando el entorno de dbt Cloud como herramienta de gestión de transformaciones sobre BigQuery.**
* **Si deseas revisar la lógica: Todo el código fuente de los modelos y transformaciones se encuentra disponible en la carpeta /models. Cada archivo .sql contiene la lógica de negocio aplicada y puede ser leído directamente para entender el flujo de transformación.**
* **Si deseas ejecutarlo: Al ser un proyecto configurado en la plataforma de dbt Cloud, la ejecución depende de una conexión activa a un proyecto de BigQuery. Como este es un entorno de prueba, el flujo está diseñado para ser visualizado a través de los archivos de código compartidos.**

Al desarrollar este proyecto, me enfoque principalmente en escribir código limpio, modular y, sobre todo, organizado. Más allá de resolver los requerimientos, busqué que cualquier otra persona que revise este proyecto pueda entenderlo y mantenerlo fácilmente conforme crezca.

Espero que la solución les resulte clara. Estoy totalmente abierto a platicar sobre las decisiones que tomé o a profundizar en cualquier parte del código.
Muchas gracias por la oportunidad de formar parte del proceso con esta prueba y estoy al pendiente de los pasos siguientes del proceso.

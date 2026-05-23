{% macro clean_text(column_name) %}
    -- Esta macro quita espacios a los lados y la pasa a minúsculas
    LOWER(TRIM({{ column_name }}))
{% endmacro %}
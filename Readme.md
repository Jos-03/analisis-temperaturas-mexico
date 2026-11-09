Descripción del Proyecto
Este proyecto es un Pipeline ETL (Extract, Transform, Load) End-to-End diseñado para procesar, modelar y visualizar 8 años de datos históricos de temperaturas en México (2017-2024). 

El objetivo principal es demostrar competencias técnicas en Ingeniería y Análisis de Datos, transformando un dataset crudo en formato Excel (no relacional y con errores de calidad) en un Data Warehouse optimizado y un dashboard interactivo para la toma de decisiones.

 Arquitectura de Datos y Flujo del Pipeline

El proyecto sigue una arquitectura por capas, separando la ingesta, el modelado y la visualización:


[ Fuente de Datos ]        [ Procesamiento ]             [ Almacenamiento ]           [ Consumo ]
    Excel (Raw)     ──>   Python (Pandas)       ──>   SQL Server (Data Warehouse) ──>  Power BI
                     (Limpieza y Unpivot)           (Esquema de Estrella + Vistas)   (Dashboards)
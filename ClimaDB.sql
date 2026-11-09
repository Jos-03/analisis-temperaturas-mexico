use ClimateDB

CREATE TABLE dim_Tiempo (
tiempo_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
anio INT NOT NULL,
mes VARCHAR(20) NOT NULL,
nombre_mes VARCHAR(20) NOT NULL
)

CREATE TABLE dim_Entidad (
entidad_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
nombre_entidad VARCHAR(100),
region VARCHAR(100)
)

CREATE TABLE fact_Temperaturas (
fact_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
temperatura DECIMAL(5,2) NOT NULL,
tiempo_id INT NOT NULL,
entidad_id INT NOT NULL,
FOREIGN KEY (tiempo_id) REFERENCES dim_Tiempo(tiempo_id),
FOREIGN KEY (entidad_id) REFERENCES dim_Entidad(entidad_id)
)

---------------------------------------------------------INSERT---------------------------------------------------------
INSERT INTO dim_Tiempo (anio, mes, nombre_mes) 
SELECT anio, mes,UPPER(LEFT(Mes, 1)) + LOWER(SUBSTRING(Mes, 2, LEN(Mes))) AS nombre_mes
FROM stg_Temperaturas
GROUP BY anio, mes; 

SELECT * FROM dim_Tiempo;

----------------------------------------------------------INSERT---------------------------------------------------------
INSERT INTO dim_Entidad (nombre_entidad, region)
SELECT 
    ENTIDAD,
    CASE 
        WHEN ENTIDAD IN ('BAJA CALIFORNIA', 'BAJA CALIFORNIA SUR', 'CHIHUAHUA', 'DURANGO', 'SINALOA', 'SONORA') THEN 'Noroeste'
        WHEN ENTIDAD IN ('COAHUILA', 'NUEVO LEÓN', 'TAMAULIPAS') THEN 'Noreste'
        WHEN ENTIDAD IN ('COLIMA', 'JALISCO', 'MICHOACÁN', 'NAYARIT') THEN 'Occidente'
        WHEN ENTIDAD IN ('HIDALGO', 'PUEBLA', 'TLAXCALA', 'VERACRUZ') THEN 'Oriente'
        WHEN ENTIDAD IN ('AGUASCALIENTES', 'GUANAJUATO', 'QUERÉTARO', 'SAN LUIS POTOSÍ', 'ZACATECAS') THEN 'Centronorte'
        WHEN ENTIDAD IN ('CIUDAD DE MÉXICO', 'ESTADO DE MÉXICO', 'MORELOS') THEN 'Centrosur'
        WHEN ENTIDAD IN ('CAMPECHE', 'QUINTANA ROO', 'TABASCO', 'YUCATÁN') THEN 'Sureste'
        WHEN ENTIDAD IN ('CHIAPAS', 'GUERRERO', 'OAXACA') THEN 'Suroeste'
        ELSE 'Sin Región'
    END AS region
FROM stg_Temperaturas
GROUP BY ENTIDAD;

SELECT * FROM dim_Entidad;

----------------------------------------------------------INSERT---------------------------------------------------------
INSERT INTO fact_Temperaturas(temperatura, tiempo_id, entidad_id)
SELECT
    st.Temperatura,
    dt.tiempo_id,
    de.entidad_id
FROM stg_Temperaturas st
INNER JOIN dim_Tiempo dt ON st.ANIO = dt.anio AND st.Mes = dt.mes 
INNER JOIN dim_Entidad de ON st.ENTIDAD = de.nombre_entidad

SELECT TOP 10 * FROM fact_Temperaturas;

--------------------------------------------------------VIEWS------------------------------------------------------------
CREATE VIEW vw_PromedioAnual AS 
SELECT
    dt.anio,
    AVG(ft.temperatura) AS temperatura_promedio
FROM fact_Temperaturas ft
INNER JOIN dim_Tiempo dt ON ft.tiempo_id = dt.tiempo_id
GROUP BY dt.anio;

SELECT * FROM vw_PromedioAnual;

CREATE VIEW vw_RankingEstados AS
SELECT 
    de.nombre_entidad,
    de.region,
    AVG(ft.temperatura) AS temperatura_promedio
FROM dim_Entidad de
INNER JOIN fact_Temperaturas ft ON de.entidad_id = ft.entidad_id
GROUP BY de.nombre_entidad, de.region

select * from vw_RankingEstados


CREATE VIEW vw_Estacionalidad AS
SELECT
    dt.nombre_mes,
   AVG(ft.temperatura) AS temperatura_promedio  
FROM fact_Temperaturas ft
INNER JOIN dim_Tiempo dt ON ft.tiempo_id = dt.tiempo_id
GROUP BY dt.nombre_mes

select * from vw_Estacionalidad

CREATE VIEW vw_TempEstadoMes AS
SELECT 
    de.nombre_entidad,
    dt.nombre_mes,
    dt.mes AS numero_mes,
    AVG(ft.temperatura) AS temperatura_promedio
FROM fact_Temperaturas ft
INNER JOIN dim_Entidad de ON ft.entidad_id = de.entidad_id
INNER JOIN dim_Tiempo dt ON ft.tiempo_id = dt.tiempo_id
GROUP BY de.nombre_entidad, dt.nombre_mes, dt.mes;
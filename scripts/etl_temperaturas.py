import pandas as pd
import sqlalchemy as sa
"""crear engine para la conexion a la base de datos"""
from sqlalchemy import create_engine

"""lectura del archivo de excel"""
df_estados = pd.read_excel(r"data\Promedio de Temperaturas.xlsx")
print (df_estados.head(10)) #PRIMEROS DIEZ REGISTROS
print(df_estados.info()) #INFORMACIÓN DE LOS ATRIBUTOS DE LAS TABLAS

"""Remombrar columnas"""
df_estados = df_estados.rename(columns={"AÑO": "ANIO"})
print(df_estados.columns)
"""Identificar NACIONAL y MOVERLO"""
df_nacional = df_estados[df_estados['ENTIDAD'] == 'NACIONAL']
"""Identificar filas donde ENTIDAD sea diferente de  NACIONAL"""
df_entidad = df_estados[df_estados['ENTIDAD'] != 'NACIONAL']

df_estados = df_entidad

print(df_estados.head(10))

"""Transformar el DataFrame de ancho a largo"""
df_largo = pd.melt(
    df_estados, 
    id_vars=['ANIO', 'ENTIDAD'], 
    value_vars=['ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO', 'JULIO', 'AGOSTO', 'SEPTIEMBRE', 'OCTUBRE', 'NOVIEMBRE', 'DICIEMBRE'], 
    var_name='Mes', 
    value_name='Temperatura'
)

print(df_largo.head(20))

print(len(df_largo))

"""CREAR CONEXION A LA BASE DE DATOS"""
engine = create_engine("mssql+pyodbc://@localhost/ClimateDB?driver=ODBC+Driver+17+for+SQL+Server&trusted_connection=yes")

"""GUARDAR LOS DATOS EN LA BASE DE DATOS"""
df_largo.to_sql('stg_Temperaturas', con=engine, if_exists='replace', index=False)

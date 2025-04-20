import pandas as pd
from etl.utils.adjust_stock import adjust_quantity_column
from etl.utils.decode import safe_decode_column
from etl.utils.schema import verify_or_create_schema

async def extract_table(config, source_engine, destination_engine):
    try:
        print(f"Procesando tabla '{config['source_table']}'...")

        # Extracción de datos desde MySQL
        print(f"Ejecutando consulta en MySQL para la tabla '{config['source_table']}'...")
        df = pd.read_sql(config["query"], source_engine)

        # Re-codificar las columnas para manejar caracteres especiales
        df = safe_decode_column(df)

        # Verificar y ajustar la columna 'cantidad' si existe
        df = adjust_quantity_column(df)

        print(f"Datos extraídos: {df.shape[0]} filas")

        # Verificar y crear esquema en PostgreSQL si no existe
        verify_or_create_schema(config["schema"], destination_engine)

        # Cargar datos en PostgreSQL
        print(f"Cargando datos en PostgreSQL para la tabla '{config['target_table']}'...")
        df.to_sql(config["target_table"], destination_engine, schema=config["schema"], if_exists='append', index=False)
        print(f"Datos cargados correctamente en la tabla '{config['target_table']}'.")
    
    except Exception as e:
        print(f"Error procesando la tabla '{config['source_table']}': {e}")
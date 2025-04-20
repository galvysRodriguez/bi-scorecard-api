from sqlalchemy.dialects.postgresql import insert
from sqlalchemy import Table, MetaData
from sqlalchemy.exc import SQLAlchemyError

def upsert_table(df, table_name, schema, engine, id_column):
    """Realiza un UPSERT en PostgreSQL usando 'ON CONFLICT DO UPDATE'."""
    if df.empty:
        print("[INFO] 📌 DataFrame vacío. No hay datos para procesar.")
        return
    
    try:
        #Cargar metadatos de la tabla
        metadata = MetaData(schema=schema)
        table = Table(table_name, metadata, autoload_with=engine)
        
        #Convertir DataFrame en diccionario de registros
        records = df.to_dict(orient="records")
        columns = df.columns.tolist()

        print(f"[INFO] 🗂️ Procesando {len(records)} registros para '{schema}.{table_name}'")
        print(f"[INFO] 📋 Columnas a insertar: {columns}")
        print(f"[INFO] 🔑 Clave primaria usada en ON CONFLICT: {id_column}")

        #Crear la sentencia INSERT
        insert_stmt = insert(table).values(records)

        # Agregar ON CONFLICT DO UPDATE
        update_stmt = insert_stmt.on_conflict_do_update(
            index_elements=[id_column],  
            set_={col: insert_stmt.excluded[col] for col in columns if col != id_column}
        )

        # Mostrar SQL generado
        print(f"[DEBUG] 📝 SQL Generado:\n{str(update_stmt)}")  
        
        with engine.connect() as conn:
            # Ejecutar el UPSERT
            result = conn.execute(update_stmt)  
            conn.commit()  

        print(f"[SUCCESS] ✅ {result.rowcount} registros insertados/actualizados en '{schema}.{table_name}'")

    except SQLAlchemyError as e:
        print(f"[ERROR] ❌ Error procesando '{table_name}': {str(e)}")
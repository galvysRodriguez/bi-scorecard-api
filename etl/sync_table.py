import pandas as pd
from sqlalchemy import text
from etl.utils.schema import verify_or_create_schema
from etl.utils.decode import safe_decode_column
from etl.utils.adjust_stock import adjust_quantity_column
from etl.utils.upsert_table import upsert_table

async def sync_table(config, source_engine, destination_engine, last_log_ids: dict):
    try:
        print(f"Procesando cambios en la tabla '{config['source_table']}'...")

        # Obtener el último ID de log procesado
        last_log_id = last_log_ids.get(config["source_table"], 0)

        # Consultar registros modificados en `log_auditoria` ordenados por `id_log` (del más antiguo al más reciente)
        log_query = f"""
            SELECT id, registro_id, operacion
            FROM logs
            WHERE tabla_afectada = '{config['source_table']}' AND id> {last_log_id}
            ORDER BY fecha ASC 
        """
        log_df = pd.read_sql(log_query, source_engine)

        if log_df.empty:
            print(f"No hay nuevos cambios en '{config['source_table']}', omitiendo carga.")
            return

        # Procesar cada cambio de manera secuencial en orden de tiempo
        for _, log_entry in log_df.iterrows():
            record_id = log_entry["registro_id"]
            operation = log_entry["operacion"]
            # ID dinámico según la tabla
            id_column = f"id_{config['target_table']}"  

            if operation in ["INSERT", "UPDATE"]:
                data_query = f"SELECT * FROM ({config['query']}) AS subquery WHERE {id_column} = {record_id}"
                df = pd.read_sql(data_query, source_engine)

                if not df.empty:
                    print(f"🔄 Procesando {operation} para registro ID {record_id} en '{config['target_table']}'...")
                    verify_or_create_schema(config["schema"], destination_engine)
                    df = safe_decode_column(df)
                    df = adjust_quantity_column(df)
                    upsert_table(df, config['target_table'], config["schema"], destination_engine, id_column)

            elif operation == "DELETE":
                with destination_engine.connect() as conn:
                    delete_query = text(f"""
                        DELETE FROM {config['schema']}.{config['target_table']}
                        WHERE {id_column} = :id
                    """)
                    result = conn.execute(delete_query, {"id": record_id})  
                    conn.commit()  

                print(f"🗑️ Eliminado registro ID {record_id} de '{config['target_table']}' ({result.rowcount} filas).")

            # Actualizar último ID de log procesado después de cada operación
            last_log_ids[config["source_table"]] = log_entry["id_log"]

        print(f"✅ Procesamiento completado para '{config['source_table']}'.")

    except Exception as e:
        print(f"❌ Error procesando '{config['source_table']}': {e}")
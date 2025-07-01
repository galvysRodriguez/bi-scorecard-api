import pandas as pd
from sqlalchemy import text
from etl.utils.schema import verify_or_create_schema
from etl.utils.decode import safe_decode_column
from etl.utils.adjust_stock import adjust_quantity_column
from etl.utils.upsert_table import upsert_table

async def sync_table(config, source_engine, destination_engine):
    try:
        print(f"Procesando cambios en la tabla '{config['source_table']}'...")

        log_query = f"""
            SELECT id, registro_id, operacion, fecha
            FROM logs
            WHERE tabla_afectada = '{config['source_table']}'
            ORDER BY fecha DESC
        """
        log_df = pd.read_sql(log_query, source_engine)

        last_sync = get_last_sync_date(destination_engine, config['source_table'])

        if last_sync:
            log_df = log_df[log_df['fecha'] > last_sync]

        if log_df.empty:
            print(f"No hay cambios posteriores a {last_sync}, omitiendo carga.")
            return

        for _, log_entry in log_df.iterrows():
            record_id = log_entry["registro_id"]
            operation = log_entry["operacion"]
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

        nueva_fecha_sync = log_df["fecha"].max()
        await save_sync_table(destination_engine, config['source_table'], nueva_fecha_sync)

        print(f"✅ Procesamiento completado para '{config['source_table']}'.")

    except Exception as e:
        print(f"❌ Error procesando '{config['source_table']}': {e}")


async def save_sync_table(destination_engine, table, fecha):
    with destination_engine.connect() as conn:
        conn.execute(text("""
            INSERT INTO sync_status (tabla, fecha)
            VALUES (:tabla, :fecha)
        """), {"tabla": table, "fecha": fecha})
        conn.commit()

def get_last_sync_date(destination_engine, table_name):
    query = text("SELECT max(fecha) fecha FROM public.sync_status WHERE tabla = :table")
    with destination_engine.connect() as conn:
        result = conn.execute(query, {"table": table_name}).fetchone()
        return result[0] if result else None
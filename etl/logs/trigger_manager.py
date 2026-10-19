from sqlalchemy import text

def create_triggers(source_engine, table):
    triggers = {
        "INSERT": f"""
        CREATE TRIGGER {table}_after_insert
        AFTER INSERT ON {table}
        FOR EACH ROW
        BEGIN
            INSERT INTO logs (tabla_afectada, operacion, registro_id)
            VALUES ('{table}', 'INSERT', NEW.id);
        END;
        """,
        "UPDATE": f"""
        CREATE TRIGGER {table}_after_update
        AFTER UPDATE ON {table}
        FOR EACH ROW
        BEGIN
            INSERT INTO logs (tabla_afectada, operacion, registro_id)
            VALUES ('{table}', 'UPDATE', NEW.id);
        END;
        """,
        "DELETE": f"""
        CREATE TRIGGER {table}_after_delete
        AFTER DELETE ON {table}
        FOR EACH ROW
        BEGIN
            INSERT INTO logs (tabla_afectada, operacion, registro_id)
            VALUES ('{table}', 'DELETE', OLD.id);
        END;
        """
    }
    with source_engine.connect() as conn:
        for trigger in triggers.values():
            try:
                # Usamos `text()` para asegurar la ejecución correcta del SQL
                conn.execute(text(trigger))
            except Exception as e:
                print(f"Error al crear el disparador para {table}: {e}")


def delete_triggers(source_engine, table):
    trigger_names = [
        f"{table}_after_insert",
        f"{table}_after_update",
        f"{table}_after_delete"
    ]

    with source_engine.connect() as conn:
        for trigger_name in trigger_names:
            try:
                # Intentamos eliminar el trigger si existe
                conn.execute(text(f"DROP TRIGGER IF EXISTS {trigger_name};"))
                print(f"Disparador eliminado: {trigger_name}")
            except Exception as e:
                print(f"Error al eliminar el disparador {trigger_name}: {e}")
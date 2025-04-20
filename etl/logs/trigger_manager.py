from sqlalchemy import text

def create_triggers(source_engine, tabla):
    triggers = {
        "INSERT": f"""
        CREATE TRIGGER {tabla}_after_insert
        AFTER INSERT ON {tabla}
        FOR EACH ROW
        BEGIN
            INSERT INTO logs (tabla_afectada, operacion, registro_id)
            VALUES ('{tabla}', 'INSERT', NEW.id);
        END;
        """,
        "UPDATE": f"""
        CREATE TRIGGER {tabla}_after_update
        AFTER UPDATE ON {tabla}
        FOR EACH ROW
        BEGIN
            INSERT INTO logs (tabla_afectada, operacion, registro_id)
            VALUES ('{tabla}', 'UPDATE', NEW.id);
        END;
        """,
        "DELETE": f"""
        CREATE TRIGGER {tabla}_after_delete
        AFTER DELETE ON {tabla}
        FOR EACH ROW
        BEGIN
            INSERT INTO logs (tabla_afectada, operacion, registro_id)
            VALUES ('{tabla}', 'DELETE', OLD.id);
        END;
        """
    }
    with source_engine.connect() as conn:
        for trigger in triggers.values():
            try:
                # Usamos `text()` para asegurar la ejecución correcta del SQL
                conn.execute(text(trigger))
            except Exception as e:
                print(f"Error al crear el disparador para {tabla}: {e}")
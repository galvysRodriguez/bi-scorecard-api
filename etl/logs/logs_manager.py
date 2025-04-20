from sqlalchemy import text

def create_table_logs(engine):
    query = """
    CREATE TABLE IF NOT EXISTS logs (
        id SERIAL PRIMARY KEY,
        tabla_afectada VARCHAR(255),
        operacion VARCHAR(10),
        registro_id INT,
        fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    """
    # Usar el método `text()` para procesar la consulta
    with engine.connect() as conn:
        conn.execute(text(query))
        print("Tabla 'logs' creada correctamente.")
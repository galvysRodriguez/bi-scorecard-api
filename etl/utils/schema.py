from sqlalchemy import inspect

def verify_or_create_schema(schema_name, engine):
    inspector = inspect(engine)
    schemas = inspector.get_schema_names()
    if schema_name not in schemas:
        print(f"Creando esquema '{schema_name}' en PostgreSQL...")
        with engine.connect() as conn:
            conn.execute(f"CREATE SCHEMA IF NOT EXISTS {schema_name}")
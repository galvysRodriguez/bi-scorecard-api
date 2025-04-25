from sqlalchemy import text

query = """
    INSERT INTO perfil (id, perfil, estado) VALUES
    (200, 'Gerente General', 1),
    (201, 'Gerente de ventas', 1),
    (202, 'Gerente de compras', 1),
    (203, 'Gerente de almacenes', 1),
    (204, 'Analista', 1),
    (205, 'Operador BI', 1);
"""

async def create_profiles_db(source_engine):
    try:
        with source_engine.begin() as conn:
            conn.execute(text(query))
            print("✅ Creación de perfiles correctamente en la base de datos de fuente")
    except Exception as e:
        print(f"❌ Error creando perfiles: {e}")


query_delete = """
    DELETE FROM perfil
    WHERE id >= 200
"""
async def delete_profiles_db(source_engine):
    try:
        with source_engine.begin() as conn:
            conn.execute(text(query_delete))
            print("✅ Eliminacion de perfiles correctamente en la base de datos de fuente")
    except Exception as e:
        print(f"❌ Error eliminando perfiles: {e}")
from sqlalchemy import text

query = """
     INSERT INTO usuario (id, nombre, apellido, login, password, email, perfil_id) VALUES
        (200, 'Gerente', 'General', 'general', '7c4a8d09ca3762af61e59520943dc26494f8941b', 'gerenteg@gmail.com', 200),
        (201, 'Gerente', 'Venta', 'venta', '7c4a8d09ca3762af61e59520943dc26494f8941b', 'gerentev@gmail.com',201),
        (202, 'Gerente', 'Compra', 'compra', '7c4a8d09ca3762af61e59520943dc26494f8941b','gerentec@gmail.com', 202),
        (203, 'Gerente', 'Almacen', 'almacen', '7c4a8d09ca3762af61e59520943dc26494f8941b', 'gerentea@gmail.com',203),
        (204, 'Analista', 'General', 'analista', '7c4a8d09ca3762af61e59520943dc26494f8941b', 'analistag@gmail.com',204);
"""

async def create_users_db(source_engine):
    try:
        with source_engine.begin() as conn:
            conn.execute(text(query))
            print("✅ Creación de usuarios correctamente en la base de datos de fuente")
    except Exception as e:
        print(f"❌ Error creando usuarios: {e}")


query_delete = """
    DELETE FROM usuario
    WHERE id >= 200
"""
async def delete_users_db(source_engine):
    try:
        with source_engine.begin() as conn:
            conn.execute(text(query_delete))
            print("✅ Eliminacion de usuarios correctamente en la base de datos de fuente")
    except Exception as e:
        print(f"❌ Error eliminando usuarios: {e}")
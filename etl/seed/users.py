from sqlalchemy import text

query_user = """
    INSERT INTO usuario (id, nombre, apellido, login, password, email, perfil_id) VALUES
        (200, 'Gerente', 'General', 'general', '7c4a8d09ca3762af61e59520943dc26494f8941b', 'gerenteg@gmail.com', 200),
        (201, 'Gerente', 'Venta', 'venta', '7c4a8d09ca3762af61e59520943dc26494f8941b', 'gerentev@gmail.com',201),
        (202, 'Gerente', 'Compra', 'compra', '7c4a8d09ca3762af61e59520943dc26494f8941b','gerentec@gmail.com', 202),
        (203, 'Gerente', 'Almacen', 'almacen', '7c4a8d09ca3762af61e59520943dc26494f8941b', 'gerentea@gmail.com',203),
        (204, 'Analista', 'General', 'analista', '7c4a8d09ca3762af61e59520943dc26494f8941b', 'analistag@gmail.com',204);
"""
query_state = """
     INSERT INTO estado_usuario (id, usuario_id, descripcion, estado_usuario) VALUES
        (200, 200, 'registrado BI', 1),
        (201, 201, 'registrado BI', 1),
        (202, 202, 'registrado BI', 1),
        (203, 203, 'registrado BI', 1),
        (204, 204, 'registrado BI', 1);
"""
async def create_users_db(source_engine):
    try:
        with source_engine.begin() as conn:
            conn.execute(text(query_user))
            conn.execute(text(query_state))
            print("✅ Creación de usuarios correctamente en la base de datos de fuente")
    except Exception as e:
        print(f"❌ Error creando usuarios: {e}")


query_delete_state = """
    DELETE FROM estado_usuario
    WHERE id >= 200;
"""

query_delete_user = """ 
    DELETE FROM usuario
    WHERE id >= 200;
"""
async def delete_users_db(source_engine):
    try:
        with source_engine.begin() as conn:
            conn.execute(text(query_delete_state))
            conn.execute(text(query_delete_user))
            print("✅ Eliminacion de usuarios correctamente en la base de datos de fuente")
    except Exception as e:
        print(f"❌ Error eliminando usuarios: {e}")
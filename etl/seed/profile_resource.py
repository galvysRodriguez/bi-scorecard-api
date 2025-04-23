from sqlalchemy import text

query = """
    INSERT INTO recurso_perfil (id, perfil_id, recurso_id) VALUES
    #perfil de gerente general
    (102000, 200, 1538),
    (102001, 200, 1539),
    (102002, 200, 1540),
    (102003, 200, 1541),
    (102004, 200, 1542),
    (102005, 200, 1543),
    (102006, 200, 1544),
    (102106, 200, 1554),

    #perfil de ventas
    (102007, 201, 1500),
    (102008, 201, 1501),
    (102009, 201, 1502),
    (102010, 201, 1503),
    (102011, 201, 1504),
    (102012, 201, 1505),
    (102013, 201, 1506),
    (102014, 201, 1539),
    (102104, 201, 1540),
    (102016, 201, 1541),
    (102017, 201, 1542),
    (102018, 201, 1543),
    #reporte
    (102019, 201, 1546),
    #perspectiva
    (102020, 201, 1557),
    (102107, 201, 1554),

    #perfil de compras
    (102021, 202, 1500),
    (102022, 202, 1501),
    (102023, 202, 1502),
    (102024, 202, 1503),
    (102025, 202, 1504),
    (102026, 202, 1505),
    (102027, 202, 1506),
    #reporte
    (102028, 202, 1547),
    #perspectiva
    (102029, 202, 1559),
    (102108, 202, 1554),

    #perfil de almacen
    (102030, 203, 1500),
    (102031, 203, 1501),
    (102032, 203, 1502),
    (102033, 203, 1503),
    (102034, 203, 1504),
    (102035, 203, 1505),
    (102036, 203, 1506),
    #reporte
    (102037, 203, 1548),
    #perspectiva
    (102038, 203, 1558),
    (102109, 203, 1554),

    #analista
    (102039, 204, 1500),
    (102040, 204, 1501),
    (102041, 204, 1502),
    (102042, 204, 1503),
    (102043, 204, 1504),
    (102044, 204, 1505),
    (102045, 204, 1506),
    (102046, 204, 1539),
    (102047, 204, 1540),
    (102048, 204, 1541),
    (102049, 204, 1542),
    (102050, 204, 1543),
    (102110, 204, 1554);
    
    
"""

async def create_profile_resource_db(source_engine):
    try:
        with source_engine.begin() as conn:
            conn.execute(text(query))
            print("✅ Creación de perfiles correctamente en la base de datos de fuente")
    except Exception as e:
        print(f"❌ Error creando perfiles: {e}")


query_delete = """
    DELETE FROM recurso_perfil
    WHERE id >= 100000
"""
async def delete_profile_resource_db(source_engine):
    try:
        with source_engine.begin() as conn:
            conn.execute(text(query_delete))
            print("✅ Eliminacion de recurso_perfil correctamente en la base de datos de fuente")
    except Exception as e:
        print(f"❌ Error eliminando recurso_perfil: {e}")
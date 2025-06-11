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
    (102311, 201, 1567),
    (102012, 201, 1505),
    (102013, 201, 1506),
    (102014, 201, 1539),
    (102104, 201, 1540),
    (102016, 201, 1541),
    (102017, 201, 1542),
    (102018, 201, 1543),
    
    #reporte
    (102019, 201, 1546),
    (102119, 201, 1561),
    #perspectiva
    (102020, 201, 1557),
    (102107, 201, 1554),

    #perfil de compras
    (102021, 202, 1500),
    (102022, 202, 1501),
    (102023, 202, 1502),
    (102024, 202, 1503),
    (102025, 202, 1504),
    (102325, 202, 1567),
    (102026, 202, 1505),
    (102027, 202, 1506),
    (102314, 201, 1539),
    (102304, 201, 1540),
    (102316, 201, 1541),
    (102317, 201, 1542),
    (102318, 201, 1543),
    #reporte
    (102028, 202, 1547),
    (102118, 202, 1560),
    #perspectiva
    (102029, 202, 1559),
    (102108, 202, 1554),

    #perfil de almacen
    (102030, 203, 1500),
    (102031, 203, 1501),
    (102032, 203, 1502),
    (102033, 203, 1503),
    (102034, 203, 1504),
    (102334, 203, 1567),
    (102035, 203, 1505),
    (102036, 203, 1506),
    (102214, 201, 1539),
    (102204, 201, 1540),
    (102216, 201, 1541),
    (102217, 201, 1542),
    (102218, 201, 1543),
    #reporte
    (102037, 203, 1548),
    #perspectiva
    (102038, 203, 1558),
    (102109, 203, 1554),

    #analista
    #todas las de targets individualizadas pero sin perspectivas
    (102039, 204, 1500),
    (102040, 204, 1501),
    (102041, 204, 1502),
    (102042, 204, 1503),
    (102043, 204, 1504),
    (102343, 204, 1567),
    (102044, 204, 1505),
    (102045, 204, 1506),
     #globales para formula, indicator, icons, tags
    (102046, 204, 1539),
    (102047, 204, 1540),
    (102048, 204, 1541),
    (102049, 204, 1542),
    (102050, 204, 1543),
    #acceso dashboard
    (102110, 204, 1554),

     #operador BI
     #ver objetivos, editar perspectivas, y todo con etiquetas y formulas
     (102111, 205, 1554),
     #solo de target los get y get:id
     (102051, 205, 1505),
     (102052, 205, 1507),

     #globales para formula, indicator, icons, tags
     (102053, 205, 1539),
     (102054, 205, 1540),
     (102055, 205, 1541),
     (102056, 205, 1543),

     #todas las de perspectivas individualizados
     (102057, 205, 1524),
     (102058, 205, 1525),
     (102059, 205, 1527),
     (102060, 205, 1528),
     (102061, 205, 1529),
     (102062, 205, 1530),

     #operador lectura
     #permiso de todos los gets sin operaciones de modificacion
     (102111, 206, 1554),
     (102061, 206, 1562),
     (102062, 206, 1563),
     (102063, 206, 1564),
     (102064, 206, 1565),
     (102065, 206, 1566),
     (102068, 206, 1544)
     
     
     ;
    
"""

async def create_profile_resource_db(source_engine):
    try:
        with source_engine.begin() as conn:
            conn.execute(text(query))
            print("✅ Creación de perfil_recurso correctamente en la base de datos de fuente")
    except Exception as e:
        print(f"❌ Error creando perfil_recurso: {e}")


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
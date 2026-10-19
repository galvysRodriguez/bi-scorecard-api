from sqlalchemy import text

query = """
    INSERT INTO recurso (id, modulo, controlador, accion, recurso, activo, custom, descripcion) VALUES
    -- Targets
    (1500, 'BI', 'targets', 'get', '/targets/exist', 1, 1, 'Verificar si existe un target'),
    (1501, 'BI', 'targets', 'get', '/targets/:id', 1, 1, 'Obtener un target específico'),
    (1502, 'BI', 'targets', 'put', '/targets/:id', 1, 1, 'Actualizar un target'),
    (1503, 'BI', 'targets', 'delete', '/targets/:id', 1, 1, 'Eliminar un target'),
    (1504, 'BI', 'targets', 'get', '/targets/detail/:id', 1, 1, 'Obtener detalle de un target'),
    (1567, 'BI', 'targets', 'get', '/targets/detail/chart/:id', 1, 1, 'Obtener detalle de un target parametrizado por fecha'),
    (1505, 'BI', 'targets', 'get', '/targets', 1, 1, 'Obtener todos los targets'),
    (1506, 'BI', 'targets', 'post', '/targets', 1, 1, 'Crear un nuevo target'),
    (1507, 'BI', 'targets', 'get', '/targets/perspective/:id', 1, 1, 'Obtener targets por perspectiva'),
    (1557, 'BI', 'targets', 'get', '/targets/perspective/7', 1, 1, 'Obtener targets por venta'),
    (1558, 'BI', 'targets', 'get', '/targets/perspective/8', 1, 1, 'Obtener targets por almacen'),
    (1559, 'BI', 'targets', 'get', '/targets/perspective/11', 1, 1, 'Obtener targets por compras'),
    (1562, 'BI', 'targets', 'get', '*', 1, 1, 'get general de objetivos'),

    -- Indicators
    (1508, 'BI', 'indicators', 'get', '/indicators', 1, 1, 'Obtener todos los indicadores'),
    (1509, 'BI', 'indicators', 'get', '/indicators/tag/:id', 1, 1, 'Obtener indicadores por tag'),

    -- Formula
    (1510, 'BI', 'formula', 'get', '/formula/exist', 1, 1, 'Verificar si existe una fórmula'),
    (1511, 'BI', 'formula', 'get', '/formula', 1, 1, 'Obtener todas las fórmulas'),
    (1512, 'BI', 'formula', 'post', '/formula', 1, 1, 'Crear una nueva fórmula'),
    (1513, 'BI', 'formula', 'get', '/formula/tag', 1, 1, 'Obtener fórmulas por tag'),
    (1514, 'BI', 'formula', 'get', '/formula/tag/:id', 1, 1, 'Obtener fórmulas por tag específico'),
    (1515, 'BI', 'formula', 'get', '/formula/:id', 1, 1, 'Obtener fórmula por ID'),
    (1516, 'BI', 'formula', 'put', '/formula/:id', 1, 1, 'Actualizar fórmula'),
    (1517, 'BI', 'formula', 'delete', '/formula/:id', 1, 1, 'Eliminar fórmula'),
    (1563, 'BI', 'formula', 'get', '*', 1, 1, 'get generla de formulas'),

    -- Tags
    (1518, 'BI', 'tags', 'get', '/tags/exist', 1, 1, 'Verificar si existe un tag'),
    (1519, 'BI', 'tags', 'get', '/tags', 1, 1, 'Obtener todos los tags'),
    (1520, 'BI', 'tags', 'post', '/tags', 1, 1, 'Crear un nuevo tag'),
    (1521, 'BI', 'tags', 'get', '/tags/:id', 1, 1, 'Obtener tag por ID'),
    (1522, 'BI', 'tags', 'put', '/tags/:id', 1, 1, 'Actualizar tag'),
    (1523, 'BI', 'tags', 'delete', '/tags/:id', 1, 1, 'Eliminar tag'),
    (1564, 'BI', 'tags', 'get', '/tags/exist', 1, 1, 'get general de tags'),

    -- Perspectives
    (1524, 'BI', 'perspectives', 'get', '/perspectives/exist', 1, 1, 'Verificar si existe una perspectiva'),
    (1525, 'BI', 'perspectives', 'get', '/perspectives', 1, 1, 'Obtener todas las perspectivas'),
    (1526, 'BI', 'perspectives', 'post', '/perspectives', 1, 1, 'Crear nueva perspectiva'),
    (1527, 'BI', 'perspectives', 'get', '/perspectives/icons', 1, 1, 'Obtener íconos de perspectivas'),
    (1528, 'BI', 'perspectives', 'get', '/perspectives/:id', 1, 1, 'Obtener perspectiva por ID'),
    (1529, 'BI', 'perspectives', 'put', '/perspectives/:id', 1, 1, 'Actualizar perspectiva'),
    (1530, 'BI', 'perspectives', 'delete', '/perspectives/:id', 1, 1, 'Eliminar perspectiva'),
    (1565, 'BI', 'perspectives', 'get', '*', 1, 1, 'get general de perspective'),

    -- Icons
    (1531, 'BI', 'icons', 'get', '/icons/exist', 1, 1, 'Verificar si existe un ícono'),
    (1532, 'BI', 'icons', 'get', '/icons', 1, 1, 'Obtener todos los íconos'),
    (1533, 'BI', 'icons', 'post', '/icons', 1, 1, 'Crear nuevo ícono'),
    (1534, 'BI', 'icons', 'get', '/icons/:id', 1, 1, 'Obtener ícono por ID'),
    (1535, 'BI', 'icons', 'put', '/icons/:id', 1, 1, 'Actualizar ícono'),
    (1536, 'BI', 'icons', 'delete', '/icons/:id', 1, 1, 'Eliminar ícono'),
    (1566, 'BI', 'icons', 'get', '*', 1, 1, 'get general de iconos'),

    -- Accesos globales
    (1537, 'BI', '*', '*', '*', 1, 1, 'Acceso global a todos los recursos del módulo BI'),
    (1538, 'BI', 'targets', '*', '/targets/*', 1, 1, 'Acceso completo a todas las operaciones de targets'),
    (1539, 'BI', 'indicators', '*', '/indicators/*', 1, 1, 'Acceso completo a todas las operaciones de indicadores'),
    (1540, 'BI', 'formula', '*', '/formula/*', 1, 1, 'Acceso completo a todas las operaciones de fórmulas'),
    (1541, 'BI', 'tags', '*', '/tags/*', 1, 1, 'Acceso completo a todas las operaciones de tags'),
    (1542, 'BI', 'perspectives', '*', '/perspectives/*', 1, 1, 'Acceso completo a todas las operaciones de perspectivas'),
    (1543, 'BI', 'icons', '*', '/icons/*', 1, 1, 'Acceso completo a todas las operaciones de íconos'),
    (1544, 'BI', 'reports', '*', '/reports/*', 1, 1, 'Acceso completo a todos los reportes'),
    (1545, 'BI', 'etl', '*', '/etl/*', 1, 1, 'Acceso completo a todas las operaciones ETL'),

    -- Reports
    (1546, 'BI', 'reports', 'get', '/reports/sale', 1, 1, 'Obtener reporte de ventas'),
    (1547, 'BI', 'reports', 'get', '/reports/purchase', 1, 1, 'Obtener reporte de compras'),
    (1548, 'BI', 'reports', 'get', '/reports/warehouse', 1, 1, 'Obtener reporte de almacén'),
    (1560, 'BI', 'reports', 'get', '/reports/order', 1, 1, 'Obtener reporte de ordenes de compras'),
    (1561, 'BI', 'reports', 'get', '/reports/quote', 1, 1, 'Obtener reporte de cotizaciones'),
    
    -- ETL
    (1549, 'BI', 'etl', 'post', '/etl/logs', 1, 1, 'Registrar logs del proceso ETL'),
    (1550, 'BI', 'etl', 'post', '/etl/extract', 1, 1, 'Ejecutar proceso de extracción de datos'),
    (1551, 'BI', 'etl', 'post', '/etl/sync', 1, 1, 'Sincronizar datos en el proceso ETL'),
    (1552, 'BI', 'etl', 'post', '/etl/resource', 1, 1, 'Crear recursos en la bdd del ERP'),
    (1553, 'BI', 'etl', 'post', '/etl/clear', 1, 1, 'Limpiar datos en el proceso ETL'),

    (1554, 'BI', 'dashboard', '*', '*', 1, 1, 'Acceso a todo el dashboard'),

    (1555, 'BI', 'dashboard', 'get', '/dashboard/target', 1, 1, 'Acceso al status de objetivos'),
    (1556, 'BI', 'dashboard', 'get', '/dashboard/metrics', 1, 1, 'Acceso a las metricas principales');
    ;
"""

async def create_resources_db(source_engine):
    try:
        with source_engine.begin() as conn:
            conn.execute(text(query.replace(':id', '\\:id')))
            print("✅ Creación de recursos correctamente en la base de datos de fuente")
    except Exception as e:
        print(f"❌ Error creando recursos: {e}")


query_delete = """
    DELETE FROM recurso 
    WHERE id >= 1500
"""
async def delete_resources_db(source_engine):
    try:
        with source_engine.begin() as conn:
            conn.execute(text(query_delete))
            print("✅ Eliminacion de recursos correctamente en la base de datos de fuente")
    except Exception as e:
        print(f"❌ Error eliminando recursos: {e}")
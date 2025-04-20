from sqlalchemy import text

query = """
    INSERT INTO recurso (modulo, controlador, accion, recurso, activo, custom, descripcion) VALUES
    ('BI', '*', '*', '*', 1, 1, 'Acceso global a todos los recursos del módulo BI'),
    ('BI', 'targets', '*', '/targets/*', 1, 1, 'Acceso completo a todas las operaciones de objetivos'),
    ('BI', 'targets', 'get', '/targets/:id', 1, 1, 'Obtener un objetivo específico por ID'),
    ('BI', 'targets', 'getAll', '/targets', 1, 1, 'Obtener todos los objetivos'),
    ('BI', 'targets', 'create', '/targets', 1, 1, 'Crear un nuevo objetivo'),
    ('BI', 'targets', 'update', '/targets/:id', 1, 1, 'Actualizar un objetivo existente'),
    ('BI', 'targets', 'delete', '/targets/:id', 1, 1, 'Eliminar un objetivo'),
    ('BI', 'formula', '*', '/formula/*', 1, 1, 'Acceso completo a todas las operaciones de fórmulas'),
    ('BI', 'formula', 'get', '/formula/:id', 1, 1, 'Obtener una fórmula específica por ID'),
    ('BI', 'formula', 'getAll', '/formula', 1, 1, 'Obtener todas las fórmulas'),
    ('BI', 'formula', 'create', '/formula', 1, 1, 'Crear una nueva fórmula'),
    ('BI', 'formula', 'update', '/formula/:id', 1, 1, 'Actualizar una fórmula existente'),
    ('BI', 'formula', 'delete', '/formula/:id', 1, 1, 'Eliminar una fórmula'),
    ('BI', 'perspectives', '*', '/perspectives/*', 1, 1, 'Acceso completo a todas las operaciones de perspectivas'),
    ('BI', 'perspectives', 'get', '/perspectives/:id', 1, 1, 'Obtener una perspectiva específica por ID'),
    ('BI', 'perspectives', 'getAll', '/perspectives', 1, 1, 'Obtener todas las perspectivas'),
    ('BI', 'perspectives', 'create', '/perspectives', 1, 1, 'Crear una nueva perspectiva'),
    ('BI', 'perspectives', 'update', '/perspectives/:id', 1, 1, 'Actualizar una perspectiva existente'),
    ('BI', 'perspectives', 'delete', '/perspectives/:id', 1, 1, 'Eliminar una perspectiva'),
    ('BI', 'tags', '*', '/tags/*', 1, 1, 'Acceso completo a todas las operaciones de etiquetas'),
    ('BI', 'tags', 'get', '/tags/:id', 1, 1, 'Obtener una etiqueta específica por ID'),
    ('BI', 'tags', 'getAll', '/tags', 1, 1, 'Obtener todas las etiquetas'),
    ('BI', 'tags', 'create', '/tags', 1, 1, 'Crear una nueva etiqueta'),
    ('BI', 'tags', 'update', '/tags/:id', 1, 1, 'Actualizar una etiqueta existente'),
    ('BI', 'tags', 'delete', '/tags/:id', 1, 1, 'Eliminar una etiqueta'),
    ('BI', 'icons', '*', '/icons/*', 1, 1, 'Acceso completo a todas las operaciones de íconos'),
    ('BI', 'icons', 'get', '/icons/:id', 1, 1, 'Obtener un ícono específico por ID'),
    ('BI', 'icons', 'getAll', '/icons', 1, 1, 'Obtener todos los íconos'),
    ('BI', 'icons', 'create', '/icons', 1, 1, 'Crear un nuevo ícono'),
    ('BI', 'icons', 'update', '/icons/:id', 1, 1, 'Actualizar un ícono existente'),
    ('BI', 'icons', 'delete', '/icons/:id', 1, 1, 'Eliminar un ícono'),
    ('BI', 'reports', '*', '/reports/*', 1, 1, 'Acceso completo a todos los reportes'),
    ('BI', 'reports', 'get', '/reports/sale', 1, 1, 'Obtener reporte de ventas'),
    ('BI', 'reports', 'get', '/reports/purchase', 1, 1, 'Obtener reporte de compras'),
    ('BI', 'reports', 'get', '/reports/warehouse', 1, 1, 'Obtener reporte de almacén'),
    ('BI', 'etl', '*', '/etl/*', 1, 1, 'Acceso completo a todas las operaciones ETL'),
    ('BI', 'etl', 'post', '/etl/logs', 1, 1, 'Registrar logs del proceso ETL'),
    ('BI', 'etl', 'post', '/etl/extract', 1, 1, 'Ejecutar proceso de extracción de datos'),
    ('BI', 'etl', 'post', '/etl/sync', 1, 1, 'Sincronizar datos en el proceso ETL'),
    ('BI', 'etl', 'post', '/etl/resource', 1, 1, 'Crear recursos en la bdd del ERP'),
    ('BI', 'etl', 'post', '/etl/clear', 1, 1, 'Limpiar datos en el proceso ETL');
"""

async def create_resources_db(source_engine):
    try:
        with source_engine.begin() as conn:
            conn.execute(text(query.replace(':id', '\\:id')))
            print("✅ Creación de recursos correctamente en la base de datos de fuente")
    except Exception as e:
        print(f"❌ Error creando recursos: {e}")

from sqlalchemy import text

query = """
    -- Targets
    INSERT INTO recurso (modulo, controlador, accion, recurso, activo, custom) VALUES
    ('BI', '*', '*', '*', 1, 1),
    ('BI', 'targets', '*', '/targets/*', 1, 1),
    ('BI', 'targets', 'get', '/targets/:id', 1, 1),
    ('BI', 'targets', 'getAll', '/targets', 1, 1),
    ('BI', 'targets', 'create', '/targets', 1, 1),
    ('BI', 'targets', 'update', '/targets/:id', 1, 1),
    ('BI', 'targets', 'delete', '/targets/:id', 1, 1);

    INSERT INTO recurso (modulo, controlador, accion, recurso, activo, custom) VALUES
     ('BI', 'formula', '*', '/formula/*', 1, 1),
    ('BI', 'formula', 'get', '/formula/:id', 1, 1),
    ('BI', 'formula', 'getAll', '/formula', 1, 1),
    ('BI', 'formula', 'create', '/formula', 1, 1),
    ('BI', 'formula', 'update', '/formula/:id', 1, 1),
    ('BI', 'formula', 'delete', '/formula/:id', 1, 1);

    -- Perspectives
    INSERT INTO recurso (modulo, controlador, accion, recurso, activo, custom) VALUES
     ('BI', 'perspectives', '*', '/perspectives/*', 1, 1),
    ('BI', 'perspectives', 'get', '/perspectives/:id', 1, 1),
    ('BI', 'perspectives', 'getAll', '/perspectives', 1, 1),
    ('BI', 'perspectives', 'create', '/perspectives', 1, 1),
    ('BI', 'perspectives', 'update', '/perspectives/:id', 1, 1),
    ('BI', 'perspectives', 'delete', '/perspectives/:id', 1, 1);

    -- Tags
    INSERT INTO recurso (modulo, controlador, accion, recurso, activo, custom) VALUES
     ('BI', 'tags', '*', '/tags/*', 1, 1),
    ('BI', 'tags', 'get', '/tags/:id', 1, 1),
    ('BI', 'tags', 'getAll', '/tags', 1, 1),
    ('BI', 'tags', 'create', '/tags', 1, 1),
    ('BI', 'tags', 'update', '/tags/:id', 1, 1),
    ('BI', 'tags', 'delete', '/tags/:id', 1, 1);

    -- ICONS
    INSERT INTO recurso (modulo, controlador, accion, recurso, activo, custom) VALUES
     ('BI', 'icons', '*', '/icons/*', 1, 1),
    ('BI', 'icons', 'get', '/icons/:id', 1, 1),
    ('BI', 'icons', 'getAll', '/icons', 1, 1),
    ('BI', 'icons', 'create', '/icons', 1, 1),
    ('BI', 'icons', 'update', '/icons/:id', 1, 1),
    ('BI', 'icons', 'delete', '/icons/:id', 1, 1);

    -- Icons: reportes
    INSERT INTO recurso (modulo, controlador, accion, recurso, activo, custom) VALUES
     ('BI', 'reports', '*', '*', 1, 1),
    ('BI', 'reports', 'get', '/reports/sale', 1, 1),
    ('BI', 'reports', 'get', '/reports/purchase', 1, 1),
    ('BI', 'reports', 'get', '/reports/warehouse', 1, 1);

    -- ETL: post
    INSERT INTO recurso (modulo, controlador, accion, recurso, activo, custom) VALUES
     ('BI', 'etl', '*', '/etl/*', 1, 1),
    ('BI', 'etl', 'post', '/etl/logs', 1, 1),
    ('BI', 'etl', 'post', '/etl/extract', 1, 1),
    ('BI', 'etl', 'post', '/etl/sync', 1, 1),
    ('BI', 'etl', 'post', '/etl/clear', 1, 1);
    """

def create_resources_db(source_engine):
    try:
        with source_engine.begin() as conn:  
            conn.execute(text(query))
            print("✅ Creacion de recursos correctamente en la base de datos de fuente")
    except Exception as e:
        print(f"❌ Error creando recursos: {e}")

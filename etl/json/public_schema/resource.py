RESOURCE = {
        "source_table": "recurso",
        "target_table": "permisos",
        "schema": "public",
        "query": """SELECT 
                        r.id as id_permisos,
                        r.controlador, 
                        r.accion,
                        r.recurso,
                        r.modulo,
                        CASE 
                            WHEN r.activo = 1 THEN true
                            ELSE false
                        END as activo
                    FROM recurso r
                    WHERE r.modulo = 'BI' or r.modulo = '*'
                    """,
}
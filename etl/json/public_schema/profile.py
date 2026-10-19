PROFILE ={
        "source_table": "pefil",
        "target_table": "roles",
        "schema": "public",
        "query": """SELECT 
                        p.id as id_roles,
                        p.perfil as rol,
                        CASE 
                            WHEN p.estado = 1 THEN true
                            ELSE false
                        END as acceso
                    FROM perfil p"""
}
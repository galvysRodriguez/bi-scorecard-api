PROFILE ={
        "source_table": "pefil",
        "target_table": "roles",
        "schema": "public",
        "query": """SELECT 
                        p.id as id_role_permiso,
                        p.perfil as rol
                        CASE 
                            WHEN p.estado = 1 THEN true
                            ELSE false
                        END as estado
                    FROM perfil p"""
}
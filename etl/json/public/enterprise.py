ENTERPRISE = {
        "source_table": "adm_empresa",
        "target_table": "empresas",
        "schema": "public",
        "query": """SELECT 
                        id as id_empresas, 
                        nombre_comercial, 
                        razon_social,
                        rif,
                        logo,
                        telefono
        FROM adm_empresa""",
}
GROUP = {
        "source_table": "adm_grupos",
        "target_table": "categorias",
        "schema": "productos",
        "query": """SELECT id as id_categorias, nombre as categoria FROM adm_grupos"""
}
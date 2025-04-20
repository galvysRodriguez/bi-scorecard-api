SUBGROUP = {
        "source_table": "adm_subgrupos",
        "target_table": "subcategorias",
        "schema": "productos",
        "query": """SELECT id as id_subcategorias, nombre as subcategoria FROM adm_subgrupos"""
}
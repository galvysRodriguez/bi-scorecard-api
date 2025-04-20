PRODUCT = {
        "source_table": "adm_conceptos",
        "target_table": "productos",
        "schema": "productos",
        "query": """SELECT 
                        id AS id_productos, 
                        codigo,
                        nombre AS titulo,
                        adm_marcas_id AS id_marcas, 
                        adm_grupos_id AS id_categorias,
                        adm_subgrupos_id AS id_subcategorias,
                        adm_tipos_conceptos_id AS id_tipo_productos,
                        adm_unidades_id AS id_unidades
                    FROM adm_conceptos""",
}
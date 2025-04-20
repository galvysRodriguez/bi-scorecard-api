PRESENTATION = {
        "source_table": "adm_presentaciones",
        "target_table": "presentaciones",
        "schema": "productos",
        "query": """SELECT 
                        id AS id_presentaciones,
                        adm_conceptos_id AS id_productos,
                        modificador,
                        nombre AS presentacion
                    FROM adm_presentaciones""",
}
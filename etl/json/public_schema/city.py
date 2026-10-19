CITY = {
        "source_table": "adm_ciudad",
        "target_table": "ciudades",
        "schema": "public",
        "query": """SELECT id as id_ciudades, nombre as ciudad, adm_estado_id as id_estados FROM adm_ciudad""",
}
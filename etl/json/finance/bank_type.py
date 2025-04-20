BANK_TYPE ={
        "source_table": "adm_entidad",
        "target_table": "tipo_bancos",
        "schema": "finanzas",
        "query": """SELECT id AS id_tipo_bancos, nombre AS tipo FROM adm_entidad"""
}
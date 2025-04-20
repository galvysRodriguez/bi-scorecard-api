CURRENCY = {
        "source_table": "adm_moneda",
        "target_table": "monedas",
        "schema": "finanzas",
        "query": """SELECT id as id_monedas, descripcion, simbolo, nombre as moneda FROM adm_moneda"""
}
INVOICE_TYPE ={
        "source_table": "adm_tipo_facturas",
        "target_table": "tipo_facturas",
        "schema": "public",
        "query": """SELECT id as id_tipo_facturas,
                            inicial,
                            nombre as tipo
                    FROM adm_tipos_facturas""",
}
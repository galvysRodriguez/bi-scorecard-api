WAREHOUSE = {
        "source_table": "adm_depositos",
        "target_table": "depositos",
        "schema": "almacenes",
        "query": """SELECT id as id_depositos,
                            nombre as deposito
                    FROM adm_depositos""",
}
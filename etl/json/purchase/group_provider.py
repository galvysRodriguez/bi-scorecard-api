GROUP_PROVIDER = {
        "source_table": "adm_tipo_proveedor",
        "target_table": "tipo_proveedores",
        "schema": "compras",
        "query": """SELECT id as id_tipo_proveedores, nombre as tipo FROM adm_tipo_proveedor""",
}
CUSTOMER_GROUP = {
        "source_table": "adm_grupo_cliente",
        "target_table": "tipo_clientes",
        "schema": "ventas",
        "query": """SELECT id as id_tipo_clientes, nombre as tipo FROM adm_grupo_cliente"""
}
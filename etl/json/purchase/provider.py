PROVIDER = {
        "source_table": "adm_proveedor", 
        "target_table": "proveedores",  
        "schema": "compras",  
        "query": """
                        SELECT 
                            ap.nombre AS proveedor,
                            ap.id AS id_proveedores,
                            ap.adm_tipo_proveedor_id AS id_tipo_proveedores
                        FROM adm_proveedor ap 

        """
}
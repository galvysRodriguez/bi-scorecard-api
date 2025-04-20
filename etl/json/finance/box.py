BOX = {
        "source_table": "adm_caja", 
        "target_table": "cajas",  
        "schema": "finanzas",  
        "query": """
                        SELECT id AS id_cajas, nombre AS caja FROM adm_caja 
        """ 
}
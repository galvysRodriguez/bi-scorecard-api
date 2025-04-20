SELLER ={
        "source_table": "adm_vendedor", 
        "target_table": "vendedores",  
        "schema": "ventas",  
        "query": """
                        SELECT
                                id AS id_vendedores,
                                nombre,
                                porcentaje
                                FROM adm_vendedor
        """  
}
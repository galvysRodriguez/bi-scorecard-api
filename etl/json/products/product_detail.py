PRODUCT_DETAIL ={
        "source_table": "adm_det_conceptos",
        "target_table": "detalle_productos",
        "schema": "productos",
        "query": """SELECT 
                        id AS id_detalle_productos,
                        ingrediente AS id_ingredientes,
                        adm_conceptos_id AS id_productos,
                        cantidad, 
                        adm_unidades_id AS id_unidades
                    FROM adm_det_conceptos"""
}
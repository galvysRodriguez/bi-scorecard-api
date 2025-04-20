PURCHASE_DETAIL ={
        "source_table": "adm_det_compra",
        "target_table": "det_compra",
        "schema": "compras",
        "query": """
                    SELECT 
                        adec.id AS id_det_compra,
                        adec.adm_enc_compra_id AS id_compras,
                        adec.adm_depositos_id AS id_depositos,
                        adec.adm_conceptos_id AS id_productos,
                        adec.cantidad,
                        adec.costo_dolar AS costo,
                        adec.descuento,
                        (	
                            SELECT ap.id FROM adm_det_compra adf2 
                            LEFT JOIN adm_presentaciones ap ON ap.adm_conceptos_id = adf2.adm_conceptos_id
                            WHERE adf2.nombre_modificador = ap.nombre AND adf2.modificador = ap.modificador
                            AND adf2.id = adec.id
                            
                        ) AS id_presentaciones
                    FROM adm_det_compra adec
        """
}
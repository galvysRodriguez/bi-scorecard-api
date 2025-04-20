PURCHASE_ORDER_DETAIL ={
        "source_table": "adm_det_orden_compra",
        "target_table": "det_orden_compra",
        "schema": "compras",
        "query": """
                    SELECT 
                        adec.id AS id_det_orden_compra,
                        adec.adm_enc_orden_compra_id AS id_ordenes_compras,
                        adec.adm_depositos_id AS id_depositos,
                        adec.adm_conceptos_id AS id_productos,
                        adec.cantidad,
                        adec.costo_dolar AS costo,
                        adec.descuento
                    FROM adm_det_orden_compra adec
        """
}
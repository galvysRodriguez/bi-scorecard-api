QUOTE_DETAIL = {
        "source_table": "adm_det_presupuesto", 
        "target_table": "det_cotizacion",  
        "schema": "ventas",  
        "query": """
                    SELECT
                            adf.id AS id_det_cotizacion,
                            adf.adm_conceptos_id AS id_productos,
                            adf.adm_depositos_id AS id_depositos,
                            adf.precio_dolar AS precio,
                            adf.descuentopro AS descuento,
                            adf.adm_enc_presupuesto_id AS id_cotizaciones,
                            adf.cantidad,
                            adf.adm_vendedor_id AS id_vendedores
                    FROM adm_det_presupuesto adf
        """,  
}
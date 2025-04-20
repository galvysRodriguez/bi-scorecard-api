PURCHASE_ORDER ={
        "source_table": "adm_enc_orden_compra",
        "target_table": "ordenes_compras",
        "schema": "compras",
        "query": """
                    SELECT 
                        aec.id AS id_ordenes_compras,
                        aec.adm_proveedor_id AS id_proveedores,
                        aec.descuento_dolar AS descuento,
                        aec.fecha_at AS fecha,
                        COALESCE(ROUND((aec.subtotal/aec.subtotal_dolar),2),0) AS tasa
                    FROM adm_enc_orden_compra aec
        """,
}
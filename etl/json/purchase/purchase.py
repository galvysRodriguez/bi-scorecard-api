PURCHASE = {
        "source_table": "adm_enc_compra",
        "target_table": "compras",
        "schema": "compras",
        "query": """
                    SELECT 
                        aec.id AS id_compras,
                        aec.numero_factura AS num_factura,
                        aec.numero_control AS num_control,
                        aec.adm_tipos_facturas_id AS id_tipo_facturas,
                        aec.adm_enc_orden_compra_id AS id_ordenes_compras,
                        aec.adm_proveedor_id AS id_proveedores,
                        aec.descuento_dolar AS descuento,
                        aec.fecha_at AS fecha,
                        COALESCE(ROUND((aec.subtotal/aec.subtotal_dolar),2),0) AS tasa
                    FROM adm_enc_compra aec
        """,
}
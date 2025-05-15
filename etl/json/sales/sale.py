SALE = {
        "source_table": "adm_enc_facturas", 
        "target_table": "ventas",  
        "schema": "ventas",  
        "query": """
                        SELECT
                            aef.id AS id_ventas,
                            aef.adm_tipos_facturas_id AS id_tipo_facturas,
                            aef.numero_factura AS num_control,
                            aef.numero_fiscal AS num_factura,
                            aef.tasa,
                            aef.adm_clientes_id AS id_personas,
                            aef.adm_caja_id AS id_cajas,
                            ac.adm_grupo_cliente_id AS id_tipo_clientes,
                            ac.adm_estado_id AS id_estados,
                            ac.adm_ciudad_id id_ciudades,
                            aef.fecha_at as fecha
                        FROM adm_enc_facturas aef
                        LEFT JOIN adm_clientes ac ON aef.adm_clientes_id = ac.id
        """,  
}
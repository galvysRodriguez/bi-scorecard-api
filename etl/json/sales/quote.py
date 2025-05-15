QUOTE = {
        "source_table": "adm_enc_presupuesto", 
        "target_table": "cotizaciones",  
        "schema": "ventas",  
        "query": """
                        SELECT
                            aef.id AS id_cotizaciones,
                            aef.numero_factura AS num_control,
                            round(aef.subtotal/aef.subtotal_dolar, 4) as tasa,
                            aef.adm_clientes_id AS id_personas,
                            ac.adm_grupo_cliente_id AS id_tipo_clientes,
                            ac.adm_estado_id AS id_estados,
                            ac.adm_ciudad_id id_ciudades,
                            aef.fecha_at as fecha
                        FROM adm_enc_presupuesto aef
                        LEFT JOIN adm_clientes ac ON aef.adm_clientes_id = ac.id
        """,  
}
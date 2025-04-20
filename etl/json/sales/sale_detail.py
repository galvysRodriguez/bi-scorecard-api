SALE_DETAIL = {
        "source_table": "adm_det_facturas", 
        "target_table": "det_venta",  
        "schema": "ventas",  
        "query": """
                        SELECT
                            adf.id AS id_det_venta,
                            adf.adm_conceptos_id AS id_productos,
                            adf.adm_depositos_id AS id_depositos,
                            adf.precio_dolar AS precio,
                            adf.descuentoDol_par AS descuento,
                            adf.cantidad,
                            adf.adm_vendedor_id AS id_empleados,
                            adf.adm_enc_facturas_id AS id_ventas,
                            (	
                                SELECT ap.id FROM adm_det_facturas adf2 
                                LEFT JOIN adm_presentaciones ap ON ap.adm_conceptos_id = adf2.adm_conceptos_id
                                WHERE adf2.nombre_modificador = ap.nombre AND adf2.modificador = ap.modificador
                                AND adf2.id = adf.id
                                
                            ) AS id_presentaciones,
                            COALESCE(adf.devuelto_parcial,0) as devuelto
                            

                        FROM adm_det_facturas adf
        """ 
}
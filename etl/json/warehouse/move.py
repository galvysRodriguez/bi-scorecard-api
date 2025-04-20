MOVE = {
        "source_table": "adm_movimiento_inventario",
        "target_table": "movimientos",
        "schema": "almacenes",
        "query": """SELECT 
                        m.id AS id_movimientos,
                        m.adm_conceptos_id AS id_productos,
                        m.adm_depositos_id AS id_depositos,
                        
                        CASE 
                        WHEN m.tipo = 'SAL' AND m.origen = 'AJU' THEN 
                            COALESCE((
                                SELECT SUM(
                                    CASE 
                                        WHEN ant.tipo = 'ENT' THEN ant.cantidad
                                        WHEN ant.tipo = 'SAL' THEN -ant.cantidad
                                        ELSE 0
                                    END
                                )
                                FROM adm_movimiento_inventario AS ant
                                WHERE ant.adm_conceptos_id = m.adm_conceptos_id
                                AND ant.adm_depositos_id = m.adm_depositos_id
                                AND ant.fecha_at < m.fecha_at
                            ), 0) - m.cantidad
                            
                        WHEN m.tipo = 'ENT' AND m.origen = 'AJU' THEN 
                            m.cantidad - COALESCE((
                                SELECT SUM(
                                    CASE 
                                        WHEN ant.tipo = 'ENT' THEN ant.cantidad
                                        WHEN ant.tipo = 'SAL' THEN -ant.cantidad
                                        ELSE 0
                                    END
                                )
                                FROM adm_movimiento_inventario AS ant
                                WHERE ant.adm_conceptos_id = m.adm_conceptos_id
                                AND ant.adm_depositos_id = m.adm_depositos_id
                                AND ant.fecha_at < m.fecha_at
                            ), 0) 
                        ELSE m.cantidad
                        END AS cantidad,
                        CASE 
                            WHEN m.origen = 'FAC' THEN 1
                            WHEN m.origen = 'AUTOCONSUMO' THEN 2
                            WHEN m.origen = 'ENS' THEN 3
                            WHEN m.origen = 'TRA' THEN 4
                            WHEN m.origen = 'AJU' THEN 5
                            WHEN m.origen = 'RETIRO' THEN 6
                            WHEN m.origen = 'OTRO' THEN 7
                            WHEN m.origen = 'NC' THEN 8
                            WHEN m.origen = 'REC' THEN 10
                            WHEN m.origen = 'COM' THEN 11
                            WHEN m.origen = 'CAR' THEN 12
                            ELSE NULL
                        END AS id_tipo_movimientos,
                        
                        m.fecha_at AS fecha, 
                        CASE
                            WHEN m.tipo = 'SAL' THEN 0
                            WHEN m.tipo = 'ENT' THEN 1
                            ELSE NULL 
                        END AS entrada
                    FROM adm_movimiento_inventario m

                    """,

    }
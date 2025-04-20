EXPENSE = {
        "source_table": "adm_movimientos_caja",
        "target_table": "egresos",
        "schema": "finanzas",
        "query": """SELECT 
                        amc.id AS id_mov_egresos,
                        amc.credito_dolar AS monto,
                        amc.fecha_at AS fecha,
                        amc.adm_tipo_pago_id AS id_metodo_pagos,
                        (SELECT am.id AS id_monedas 
                        FROM adm_moneda am
                        WHERE LEFT(am.descripcion, 3) = LEFT(amc.moneda, 3)
                        ) AS id_monedas,
                            CASE
                                when amc.origen = 'ABONO' then 1
                                when amc.origen = 'COMPRA'  then 2
                                when amc.origen = 'FACTURA' then 3
                                when amc.origen = 'PEDIDO' then 4
                                when amc.origen = 'INGRESO' then 5
                                when amc.origen = 'RETIRO' then 6
                                when amc.origen = 'BANCO' then 7
                            END AS id_tipo_movimientos,
                            2 AS id_medios
                    FROM adm_movimientos_caja amc
                    WHERE amc.credito > 0
                    AND (amc.adm_banco_id = 0 OR amc.adm_banco_id IS NULL)""",
    },
{
        "source_table": "adm_movimientos_bancos",
        "target_table": "egresos",
        "schema": "finanzas",
        "query": """SELECT 
                        amc.id AS id_mov_egresos,
                        amc.credito_dolar AS monto,
                        amc.fecha_at AS fecha,
                        amc.adm_tipo_pago_id AS id_metodo_pagos,
                        (SELECT am.id AS id_monedas 
                        FROM adm_moneda am
                        WHERE LEFT(am.descripcion, 3) = LEFT(amc.moneda, 3)
                        ) AS id_monedas,
                            CASE
                                when amc.origen = 'ABONO' then 1
                                when amc.origen = 'COMPRA'  then 2
                                when amc.origen = 'FACTURA' then 3
                                when amc.origen = 'PEDIDO' then 4
                                when amc.origen = 'INGRESO' then 5
                                when amc.origen = 'RETIRO' then 6
                                when amc.origen = 'BANCO' then 7
                            END AS id_tipo_movimientos,
                            1 AS id_medios
                    FROM adm_movimientos_bancos amc
                    WHERE amc.credito>0""",
    }
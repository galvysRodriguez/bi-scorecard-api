INCOME_BANK ={
        "source_table": "adm_movimientos_bancos",
        "target_table": "ingreso_banco",
        "schema": "finanzas",
        "query": """SELECT 
                        amc.id AS id_ingresos,
                        amc.adm_banco_id AS id_bancos,
                        CASE 
                            WHEN amc.adm_entidad_id = 0 then null
                            ELSE amc.adm_entidad_id
                        END AS id_tipo_bancos
                    FROM adm_movimientos_bancos amc
                    WHERE amc.debito>0""",
}
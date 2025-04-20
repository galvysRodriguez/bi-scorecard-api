EXPENSE_BOX = {
        "source_table": "adm_movimientos_caja",
        "target_table": "egreso_caja",
        "schema": "finanzas",
        "query": """SELECT 
                        amc.id AS id_egresos, 
                        amc.adm_caja_id AS id_cajas
                    FROM adm_movimientos_caja amc 
                    WHERE amc.credito> 0
                    AND (amc.adm_banco_id != 0 OR amc.adm_banco_id IS NULL)""",
    },
{
        "source_table": "adm_movimientos_bancos",
        "target_table": "egreso_caja",
        "schema": "finanzas",
        "query": """SELECT 
                        amc.id AS id_egresos,
                        amc.adm_caja_id AS id_cajas
                    FROM adm_movimientos_bancos amc
                    WHERE amc.credito>0
                    AND (amc.adm_caja_id != 0 AND amc.adm_caja_id IS not NULL)""",
}
BANK = {
        "source_table": "adm_banco",
        "target_table": "bancos",
        "schema": "finanzas",
        "query": """SELECT 
                        ab.id AS id_bancos,
                        ab.cuenta,
                        ab.adm_entidad_id AS id_tipo_bancos
                    FROM adm_banco ab"""
}
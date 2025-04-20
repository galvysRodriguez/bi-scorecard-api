PAY_METHOD ={
        "source_table": "adm_tipo_pago",
        "target_table": "metodo_pagos",
        "schema": "finanzas",
        "query": """SELECT id as id_metodo_pagos, nombre as metodo FROM adm_tipo_pago """
}
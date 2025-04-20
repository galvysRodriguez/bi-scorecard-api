UNIT = {
        "source_table": "adm_unidades", 
        "target_table": "unidades",  
        "schema": "productos",  
        "query": "SELECT u.id as id_unidades, u.nombre as unidad FROM adm_unidades u"
}
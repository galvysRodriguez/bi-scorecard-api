PERSON ={
        "source_table": "adm_clientes", 
        "target_table": "personas",  
        "schema": "public",  
        "query": """SELECT
                            ac.id AS id_personas,
                            ac.nombre,
                            ac.nombre_comercial,
                            ac.cedula,
                            ac.fecha_nac AS fecha_nacimiento,
                            ac.telefono1 AS telefono,
                            ac.direccion,
                            ac.adm_ciudad_id AS id_ciudades,
                            ac.correo_electronico AS correo
                    FROM adm_clientes ac""" 
}
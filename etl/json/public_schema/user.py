USER ={
        "source_table": "usuario",
        "target_table": "usuarios",
        "schema": "public",
        "query": """SELECT u.id as id_usuarios, u.nombre, 
                            u.apellido, u.email as correo, 
                            u.login as nombre_usuario,  
                            u.password as contraseña,
                            u.perfil_id as id_roles,
                            CASE 
                                WHEN eu.estado_usuario = 1 THEN true
                                ELSE false
                            END as acceso
                            FROM usuario u 
                    INNER JOIN estado_usuario eu ON eu.usuario_id = u.id""",
}
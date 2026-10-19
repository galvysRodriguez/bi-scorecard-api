PROFILE_RESOURCE ={
        "source_table": "recurso_pefil",
        "target_table": "role_permiso",
        "schema": "public",
        "query": """SELECT
                        rp.recurso_id as id_permisos,
                        rp.perfil_id as id_roles
                            FROM recurso_perfil rp
                    INNER JOIN recurso r ON r.id = rp.recurso_id
                    WHERE r.modulo = 'BI' or r.modulo = '*'
                    """
}
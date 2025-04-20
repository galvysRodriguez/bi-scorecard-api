from asyncpg import Connection
from schemas.target import UserBase, PermissionBase

async def login_query(db: Connection, user: UserBase):
    query = f"""
        SELECT * FROM public.usuarios 
        WHERE acceso = TRUE and nombre_usuario = $1
    """
    return await db.fetchrow(query, user.username)

async def verify_permission_query(db: Connection, permission: PermissionBase):
    query = f"""
        SELECT * FROM public.permisos
        WHERE accion = $1 AND recurso $2 AND p.modulo = 'BI'
    """
    return await db.fetchrow(query, permission.action, permission.resource)


async def verify_permission_role_query(db: Connection, user_id:int, resource:str, action:str):
    query = f"""
        SELECT r.id_roles, rp.id_permisos FROM public.roles r
        INNER JOIN public.role_permiso rp ON r.id_roles = rp.id_roles
        INNER JOIN public.permisos p ON p.id_permisos = rp.id_permisos
        INNER JOIN public.usuarios u ON u.id_roles = r.id_roles
        WHERE (u.id_usuarios = $1 AND r.acceso = TRUE) AND 
            ((p.modulo = '*') OR 
            (p.recurso = '*') OR
            (p.recurso = $2 AND p.accion = $3))
    """
    return await db.fetchrow(query, user_id, resource, action)

  
from asyncpg import Connection
from schemas.target import UserBase, PermissionBase

async def login_query(db: Connection, user: UserBase):
    query = f"""
        SELECT 
            u.id_usuarios as id_user,
            u.correo as email,
            u.contraseña as password,
            u.nombre_usuario as username, 
            u.nombre as name,
            u.apellido as lastname,
            r.rol as role,
            r.id_roles as role_id
          FROM public.usuarios u
        INNER JOIN public.roles r ON u.id_roles = r.id_roles
        WHERE u.acceso = TRUE AND u.nombre_usuario = $1 AND r.acceso = TRUE
    """
    return await db.fetchrow(query, user.username)

async def get_permissions_by_role(db: Connection, role_id: int):
    query = """
        SELECT 
            p.modulo as module,
            p.controlador as controlator,
            p.recurso as resource,
            p.accion as action,
            p.id_permisos as id_permits
        FROM public.roles r
        INNER JOIN public.role_permiso rp ON rp.id_roles = r.id_roles
        INNER JOIN public.permisos p ON p.id_permisos = rp.id_permisos
        WHERE r.id_roles = $1
    """
    return await db.fetch(query, role_id)

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

  
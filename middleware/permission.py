from fastapi import Request, HTTPException, Depends
from auth.dependencies import get_current_user
from asyncpg import Connection
from db.database import get_db
from repositories.user_repo import verify_permission_query, verify_permission_role_query
from schemas.target import PermissionBase

async def check_access(request: Request, call_next, db: Connection = Depends(get_db)):
    if request.url.path.startswith("/docs") \
        or request.url.path.startswith("/openapi") \
        or request.url.path.startswith("/users") \
        or request.url.path.startswith("/login"):
        return await call_next(request)

    try:
        current_user = await get_current_user(request)
    except HTTPException as e:
        raise e

    resource = request.url.path.strip("/").split('/')[0] 
    action = request.method.lower()
    #permission_data = PermissionBase(resource=resource, action=action)
    #permission = verify_permission_query(db, permission_data)

    #if not permission:
        #raise HTTPException(status_code=403, detail="Permission not registered")

    user_permission = verify_permission_role_query(db, current_user['id_usuarios'])
    if not user_permission:
        raise HTTPException(status_code=403, detail="Access denied")

    return await call_next(request)

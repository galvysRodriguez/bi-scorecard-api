from fastapi import Request, HTTPException
from fastapi.responses import JSONResponse
from auth.dependencies import get_current_user
from db.database import get_db
from repositories.user_repo import verify_permission_role_query
from utils.api_response import api_response

async def check_access(request: Request, call_next):
    if request.url.path.startswith("/docs") \
        or request.url.path.startswith("/openapi") \
        or request.url.path.startswith("/users"):
        return await call_next(request)

    # Las excepciones lanzadas en un middleware terminan en 500 sin cabeceras CORS, por eso se responde directamente
    try:
        current_user = await get_current_user(request)
    except HTTPException as e:
        return JSONResponse(status_code=e.status_code, content=api_response(e.detail, False))

    resource = request.url.path.strip("/").split('/')[0]
    action = request.method.lower()

    db = await get_db()
    try:
        user_permission = await verify_permission_role_query(db, current_user['id_user'], resource, action)
    finally:
        await db.close()
    if not user_permission:
        return JSONResponse(status_code=403, content=api_response("Access denied", False))

    return await call_next(request)

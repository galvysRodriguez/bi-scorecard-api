from fastapi import Request, HTTPException
from auth.jwt_handler import decode_access_token
from repositories.user_repo import login_query, verify_permission_role_query
from schemas.target import UserBase
from jwt import ExpiredSignatureError, InvalidTokenError as JWTError
from db.database import get_db

async def get_current_user(request: Request):
    token = request.headers.get("Authorization")
    if not token or not token.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Token missing or invalid")
    token = token[7:]  

    try:
        payload = decode_access_token(token)
        username = payload.get("sub")
        if not username:
            raise HTTPException(status_code=401, detail="Invalid token")
        
        db = await get_db()
        try:
            user = await login_query(db, UserBase(username=username))
        finally:
            await db.close()

        if not user:
            raise HTTPException(status_code=401, detail="User not found")
        return user
    except ExpiredSignatureError:
        raise HTTPException(
            status_code=401,
            detail="Token expired",
            headers={"WWW-Authenticate": "Bearer"}
        )
    except JWTError:
        raise HTTPException(
            status_code=401,
            detail="Invalid token",
            headers={"WWW-Authenticate": "Bearer"}
        )
    except Exception as e:
        
        raise HTTPException(
            status_code=401,
            detail="Authentication failed"
        )
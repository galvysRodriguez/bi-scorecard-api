from fastapi import Request, HTTPException, Depends
from asyncpg import Connection
from db.database import get_db
from auth.jwt_handler import decode_access_token
from repositories.user_repo import login_query
from schemas.target import UserBase

async def get_current_user(request: Request, db: Connection = Depends(get_db)):
    token = request.headers.get("Authorization")
    if not token or not token.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Token missing or invalid")
    #remover token 7 primeros caracteres
    token = token[7:]
    
    try:
        payload = decode_access_token(token)
        username = payload.get("sub")
        if not username:
            raise HTTPException(status_code=401, detail="Invalid token")

        user_data = UserBase(username=username)
        user = await login_query(db, user_data)

        if not user:
            raise HTTPException(status_code=401, detail="User not found")

        return user
    except Exception as e:
        raise HTTPException(status_code=401, detail=str(e))

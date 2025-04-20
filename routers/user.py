from fastapi import APIRouter, Depends, Query, HTTPException
from asyncpg import Connection
from db.database import get_db
from services.user_service import login_service
from schemas.target import Token, UserBase
from typing import Optional

router = APIRouter(prefix="/users", tags=["Users"])

@router.post("/token", response_model=Token)
async def login_for_access_token(user_data: UserBase, db: Connection = Depends(get_db)):
    result = await login_service(db, user_data)
    if not result:
        raise HTTPException(status_code=401, detail="Incorrect username or password")
    return {"access_token": result, "token_type": "bearer"}
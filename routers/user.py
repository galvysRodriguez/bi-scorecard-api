from fastapi import APIRouter, Depends, Query, HTTPException,status
from asyncpg import Connection
from db.database import get_db
from services.user_service import login_service
from schemas.target import Token, UserBase
from typing import Optional
from utils.api_response import api_response
from fastapi.responses import JSONResponse

router = APIRouter(prefix="/users", tags=["Users"])

@router.post("/login", response_model=Token)
async def login_for_access_token(user_data: UserBase, db: Connection = Depends(get_db)):
    result = await login_service(db, user_data)
    if not result:
        return JSONResponse(
            status_code=status.HTTP_401_UNAUTHORIZED,
            content=api_response(
                "Credenciales inválidas",False
            )
        )
    return JSONResponse(
            status_code=status.HTTP_200_OK,
            content=api_response(
                "Inicio de sesion exitoso",True, result
            )
        )
    
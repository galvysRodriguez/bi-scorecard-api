from fastapi import APIRouter, Depends
from asyncpg import Connection
from db.database import get_db
from services.target_service import TargetService
from schemas.target import TargetCreate, TargetUpdate
from services.indicator_service import get_indicators_perspective

router = APIRouter(prefix="/targets/customer", tags=["customer"])

@router.get("/")
async def get_targets(db: Connection = Depends(get_db)):
    return await TargetService.get_targets(db, 2)

@router.get("/indicators")
async def get_targets(db: Connection = Depends(get_db)):
    return await get_indicators_perspective(db, 2)


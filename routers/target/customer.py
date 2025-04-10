from fastapi import APIRouter, Depends
from asyncpg import Connection
from db.database import get_db
from services.target_service import TargetService
from schemas.target import TargetCreate, TargetUpdate

router = APIRouter(prefix="/targets/customer", tags=["customer"])

@router.get("/")
async def get_targets(db: Connection = Depends(get_db)):
    return await TargetService.get_targets(db, 2)


from fastapi import APIRouter, Depends
from asyncpg import Connection
from db.database import get_db
from services.target_service import TargetService
from schemas.target import TargetCreate, TargetUpdate

router = APIRouter(prefix="/targets", tags=["Targets"])

@router.get("/{target_id}")
async def get_target(target_id: int, db: Connection = Depends(get_db)):
    return await TargetService.get_target(db, target_id)

@router.get("/")
async def get_targets(db: Connection = Depends(get_db)):
    return await TargetService.get_targets(db)

@router.post("/")
async def create_target(target: TargetCreate, db: Connection = Depends(get_db)):
    return await TargetService.add_target(db, target)

@router.put("/{target_id}")
async def update_target(target_id: int, target_data: TargetUpdate, db: Connection = Depends(get_db)):
    return await TargetService.update_target(db, target_id, target_data.dict(exclude_unset=True))

@router.delete("/{target_id}")
async def delete_target(target_id: int, db: Connection = Depends(get_db)):
    return await TargetService.delete_target(db, target_id)

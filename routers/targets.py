from fastapi import APIRouter, Depends
from asyncpg import Connection
from db.database import get_db
from services.target_service import TargetService
from schemas.target import TargetCreate, TargetUpdate, TargetBase

router = APIRouter(prefix="/targets", tags=["Targets"])

@router.get("/{target_id}")
async def get_target(target_id: int, db: Connection = Depends(get_db)):
    return await TargetService.get_detail_target(db, target_id)

@router.get("/")
async def get_targets(db: Connection = Depends(get_db)):
    return await TargetService.get_all_targets(db)

@router.get("/perspective/{perspective_id}")
async def get_targets_perspective(perspective_id: int, db: Connection = Depends(get_db)):
    return await TargetService.get_targets(db, perspective_id)

@router.post("/")
async def create_target(target: TargetCreate, db: Connection = Depends(get_db)):
    return await TargetService.add_target(db, target)

@router.put("/{target_id}")
async def update_target(target_id: int, target_data: TargetUpdate, db: Connection = Depends(get_db)):
    return await TargetService.update_target(db, target_id, target_data)

@router.delete("/{target_id}")
async def delete_target(target_id: int, db: Connection = Depends(get_db)):
    return await TargetService.delete_target(db, target_id)

@router.post("/exist")
async def get_target_exist(target_data: TargetBase, db: Connection = Depends(get_db)):
    return await TargetService.exist_target(db, target_data)


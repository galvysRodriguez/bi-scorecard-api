from fastapi import APIRouter, Depends, Query
from asyncpg import Connection
from db.database import get_db
from services.target_service import TargetService
from schemas.target import TargetCreate, TargetUpdate, TargetBase
from typing import Optional

router = APIRouter(prefix="/targets", tags=["Targets"])

@router.get("/exist/")
async def get_target_exist_update(title: str = Query(...), target_id:  Optional[int] = Query(None), db: Connection = Depends(get_db)):
    target_data = TargetBase(title=title)
    if target_id is not None:
        return await TargetService.exist_target_update(db, target_id, target_data)
    return await TargetService.exist_target(db, target_data)

@router.get("/{target_id}")
async def get_target(target_id: int, db: Connection = Depends(get_db)):
    return await TargetService.get_target_simple(db, target_id)

@router.get("/detail/{target_id}")
async def get_target(target_id: int, db: Connection = Depends(get_db)):
    return await TargetService.get_detail_target(db, target_id)

@router.get("/detail/chart/{target_id}")
async def get_target_chart(target_id: int, date_from: str, date_to: str, db: Connection = Depends(get_db)):
    return await TargetService.get_detail_chart_target(db, target_id, date_from, date_to)

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
async def update_target(target_id: int, target_data: TargetCreate, db: Connection = Depends(get_db)):
    return await TargetService.update_target(db, target_id, target_data)

@router.delete("/{target_id}")
async def delete_target(target_id: int, db: Connection = Depends(get_db)):
    return await TargetService.delete_target(db, target_id)





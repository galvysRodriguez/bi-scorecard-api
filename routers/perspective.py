from fastapi import APIRouter, Depends
from asyncpg import Connection
from db.database import get_db
from services.perspective_service import global_create_perspective, global_delete_perspective, global_exist_perspective, global_get_perspective, global_get_perspectives, global_update_perspective, global_get_perspectives_with_icon, global_exist_perspective_update
from schemas.target import PerspectiveCreate, PerspectiveBase

router = APIRouter(prefix="/perspectives", tags=["Perspectives"])

@router.get("/{perspective_id}")
async def get_perspective(perspective_id: int, db: Connection = Depends(get_db)):
    return await global_get_perspective(db, perspective_id)

@router.get("/")
async def get_perspectives(db: Connection = Depends(get_db)):
    return await global_get_perspectives(db)

@router.get("/icons/")
async def get_perspectives_icons(db: Connection = Depends(get_db)):
    return await global_get_perspectives_with_icon(db)

@router.post("/exist")
async def get_perspective_exist(perspective_data: PerspectiveBase, db: Connection = Depends(get_db)):
    return await global_exist_perspective(db, perspective_data)

@router.post("/exist")
async def get_perspective_exist_update(perspective_data: PerspectiveBase, perspective_id:int, db: Connection = Depends(get_db)):
    return await global_exist_perspective_update(db, perspective_id, perspective_data)

@router.post("/")
async def create_perspectives(perspective: PerspectiveCreate, db: Connection = Depends(get_db)):
    return await global_create_perspective(db, perspective)

@router.put("/{perspective_id}")
async def update_perspective(perspective_id: int, perspective_data: PerspectiveCreate, db: Connection = Depends(get_db)):
    return await global_update_perspective(db, perspective_id, perspective_data)

@router.delete("/{perspective_id}")
async def delete_target(perspective_id: int, db: Connection = Depends(get_db)):
    return await global_delete_perspective(db, perspective_id)

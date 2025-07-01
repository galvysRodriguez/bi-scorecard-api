from fastapi import APIRouter, Depends, Query
from asyncpg import Connection
from db.database import get_db
from services.perspective_service import global_create_perspective, global_delete_perspective, global_exist_perspective, global_get_perspective, global_get_perspectives, global_update_perspective, global_get_perspectives_with_icon, global_exist_perspective_update
from schemas.target import PerspectiveCreate, PerspectiveBase
from typing import Optional

router = APIRouter(prefix="/perspectives", tags=["Perspectives"])

@router.get("/exist")
async def get_perspective_exist(title: str =Query(...), perspective_id:Optional[int] =Query(None), db: Connection = Depends(get_db)):
    perspective_data = PerspectiveBase(title=title)
    if perspective_id is not None:
        return await global_exist_perspective_update(db, perspective_id, perspective_data)
    return await global_exist_perspective(db, perspective_data)

@router.get("/")
async def get_perspectives(db: Connection = Depends(get_db)):
    return await global_get_perspectives(db)

@router.get("/icons/")
async def get_perspectives_icons(db: Connection = Depends(get_db)):
    return await global_get_perspectives_with_icon(db)


@router.get("/{perspective_id}")
async def get_perspective(perspective_id: int, db: Connection = Depends(get_db)):
    return await global_get_perspective(db, perspective_id)

@router.post("/")
async def create_perspectives(perspective: PerspectiveCreate, db: Connection = Depends(get_db)):
    return await global_create_perspective(db, perspective)

@router.put("/{perspective_id}")
async def update_perspective(perspective_id: int, perspective_data: PerspectiveCreate, db: Connection = Depends(get_db)):
    return await global_update_perspective(db, perspective_id, perspective_data)

@router.delete("/{perspective_id}")
async def delete_perspective(perspective_id: int, db: Connection = Depends(get_db)):
    return await global_delete_perspective(db, perspective_id)

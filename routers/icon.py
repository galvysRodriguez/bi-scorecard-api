from fastapi import APIRouter, Depends, Query
from asyncpg import Connection
from db.database import get_db
from services.icon_service import global_create_icon, global_update_icon, global_get_icons, global_delete_icon, global_exist_icon, global_get_icon, global_exist_icon_update
from schemas.target import IconBase
from typing import Optional

router = APIRouter(prefix="/icons", tags=["icons"])


@router.get("/exist")
async def get_icon_exist(title: str = Query(...), icon_id:Optional[int] =Query(None), db: Connection = Depends(get_db)):
    icon_data = IconBase(title=title)
    if icon_id is not None:
        return await global_exist_icon_update(db, icon_id, icon_data) 
    return await global_exist_icon(db, icon_data)

@router.get("/")
async def get_icons(db: Connection = Depends(get_db)):
    return await global_get_icons(db)

@router.get("/{icon_id}")
async def get_icon(icon_id: int, db: Connection = Depends(get_db)):
    return await global_get_icon(db, icon_id)

@router.post("/")
async def create_icons(icon: IconBase, db: Connection = Depends(get_db)):
    return await global_create_icon(db, icon)

@router.put("/{icon_id}")
async def update_icon(icon_id: int, icon_data: IconBase, db: Connection = Depends(get_db)):
    return await global_update_icon(db, icon_id, icon_data)

@router.delete("/{icon_id}")
async def delete_icon(icon_id: int, db: Connection = Depends(get_db)):
    return await global_delete_icon(db, icon_id)

from fastapi import APIRouter, Depends, Query
from asyncpg import Connection
from db.database import get_db
from services.tag_service import global_create_tag, global_delete_tag, global_exist_tag, global_get_tag, global_get_tags, global_update_tag, global_exist_tag_update, global_get_tag_by_perspective
from schemas.target import TagCreate, TagBase
from typing import Optional

router = APIRouter(prefix="/tags", tags=["Tags"])

@router.get("/exist")
async def get_tag_exist(title: str = Query(...), tag_id:Optional[int] = Query(None), db: Connection = Depends(get_db)):
    tag_data = TagBase(title=title)
    if tag_id is not None:
        return await global_exist_tag_update(db, tag_id, tag_data)
    return await global_exist_tag(db, tag_data)

@router.get("/")
async def get_tags(db: Connection = Depends(get_db)):
    return await global_get_tags(db)

@router.get("/perspective/{perspective_id}")
async def get_tags(perspective_id: int, db: Connection = Depends(get_db)):
    return await global_get_tag_by_perspective(db, perspective_id)

@router.get("/{tag_id}")
async def get_tag(tag_id: int, db: Connection = Depends(get_db)):
    return await global_get_tag(db, tag_id)

@router.post("/")
async def create_tags(tag: TagCreate, db: Connection = Depends(get_db)):
    return await global_create_tag(db, tag)

@router.put("/{tag_id}")
async def update_tag(tag_id: int, tag_data: TagCreate, db: Connection = Depends(get_db)):
    return await global_update_tag(db, tag_id, tag_data)

@router.delete("/{tag_id}")
async def delete_tag(tag_id: int, db: Connection = Depends(get_db)):
    return await global_delete_tag(db, tag_id)

from fastapi import APIRouter, Depends
from asyncpg import Connection
from db.database import get_db
from services.tag_service import global_create_tag, global_delete_tag, global_exist_tag, global_get_tag, global_get_tags, global_update_tag
from schemas.target import TagCreate, TagBase

router = APIRouter(prefix="/tags", tags=["Tags"])

@router.get("/{tag_id}")
async def get_tag(tag_id: int, db: Connection = Depends(get_db)):
    return await global_get_tag(db, tag_id)

@router.get("/")
async def get_tags(db: Connection = Depends(get_db)):
    return await global_get_tags(db)

@router.post("/exist")
async def get_tag_exist(tag_data: TagBase, db: Connection = Depends(get_db)):
    return await global_exist_tag(db, tag_data)

@router.post("/")
async def create_tags(tag: TagCreate, db: Connection = Depends(get_db)):
    return await global_create_tag(db, tag)

@router.put("/{tag_id}")
async def update_tag(tag_id: int, tag_data: TagCreate, db: Connection = Depends(get_db)):
    return await global_update_tag(db, tag_id, tag_data)

@router.delete("/{tag_id}")
async def delete_target(tag_id: int, db: Connection = Depends(get_db)):
    return await global_delete_tag(db, tag_id)

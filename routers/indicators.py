from fastapi import APIRouter, Depends
from asyncpg import Connection
from services.indicator_service import get_indicators, get_indicators_tag
from db.database import get_db

router = APIRouter(prefix="/indicators", tags=["indicators"])

@router.get("/")
async def get_all_indicators(db: Connection = Depends(get_db)):
    response = await get_indicators(db)
    return response

@router.get("/tag/{tag_id}")
async def get_all_indicators_perspective(tag_id: int, db: Connection = Depends(get_db)):
    response = await get_indicators_tag(db, tag_id)
    return response




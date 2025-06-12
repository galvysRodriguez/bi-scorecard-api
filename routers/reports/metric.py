from fastapi import APIRouter, Depends, Query
from asyncpg import Connection
from db.database import get_db
from services.reports.metric_service import get_value_service
from services.target_service import TargetService
from schemas.target import IconBase
from typing import Optional

router = APIRouter(prefix="/dashboard", tags=["dashboard"])

@router.get("/metrics")
async def get_metrics(date_from: str, date_to: str,db: Connection = Depends(get_db)):
    return await get_value_service(db, date_from, date_to)

@router.get("/target")
async def get_metrics(date_from: str, date_to: str, db: Connection = Depends(get_db)):
    return await TargetService.get_target_perspectives(date_from, date_to, db)
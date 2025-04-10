from fastapi import APIRouter, Depends
from asyncpg import Connection
from db.database import get_db
from datetime import datetime
from services.target_service import TargetService
from schemas.target import TargetCreate, TargetUpdate
from services.indicator_service import fetch_indicator_value, fetch_indicator_str, fetch_indicator_grouped

router = APIRouter(prefix="/test", tags=["test"])


@router.get("/target/{target_id}")
async def get_target(target_id: int, db: Connection = Depends(get_db)):
    return await TargetService.get_target(db, target_id)
    


@router.get("/indicators/{indicator_id}/aggregation/{aggregation_id}")
async def get_indicator_value_route(indicator_id: int, aggregation_id: int, start_date, end_date, db: Connection = Depends(get_db)):
    response = await fetch_indicator_value(db, indicator_id, aggregation_id, start_date, end_date)
    return response

@router.get("/indicators/aggregation/")
async def get_indicator_value_string(indicator: str, aggregation: str, start_date:datetime, end_date:datetime, db: Connection = Depends(get_db)):
    response = await fetch_indicator_str(db, indicator, aggregation, start_date, end_date)
    return response

@router.get("/indicators/grouped")
async def get_indicator_value_string(indicator: str, aggregation: str, start_date:datetime, end_date:datetime, db: Connection = Depends(get_db)):
    response = await fetch_indicator_grouped(db, indicator, aggregation, start_date, end_date)
    return response



from fastapi import APIRouter, Depends
from datetime import datetime
from asyncpg import Connection
from services.indicator_service import fetch_indicator_value, get_indicators, fetch_indicator_str, get_indicators_with_perspective, fetch_indicator_grouped
from db.database import get_db

router = APIRouter(prefix="/indicators", tags=["indicators"])

@router.get("/indicators/{indicator_id}/aggregation/{aggregation_id}")
async def get_indicator_value_route(indicator_id: int, aggregation_id: int, start_date, end_date, db: Connection = Depends(get_db)):
    """
    API para obtener el valor de un indicador con una agregación específica.
    """
    response = await fetch_indicator_value(db, indicator_id, aggregation_id, start_date, end_date)
    return response

@router.get("/indicators/aggregation/")
async def get_indicator_value_string(indicator: str, aggregation: str, start_date:datetime, end_date:datetime, db: Connection = Depends(get_db)):
    """
    API para obtener el valor de un indicador con una agregación específica.
    """
    response = await fetch_indicator_str(db, indicator, aggregation, start_date, end_date)
    return response

@router.get("/indicators/grouped")
async def get_indicator_value_string(indicator: str, aggregation: str, start_date:datetime, end_date:datetime, db: Connection = Depends(get_db)):
    """
    API para obtener el valor de un indicador con una agregación específica.
    """
    response = await fetch_indicator_grouped(db, indicator, aggregation, start_date, end_date)
    return response



@router.get("/")
async def get_all_indicators(db: Connection = Depends(get_db)):
    """
    API para obtener una lista de indicadores con sus perspectivas
    """
    response = await get_indicators(db)
    return response

@router.get("/perspective")
async def get_all_indicators_perspective(db: Connection = Depends(get_db)):
    """
    API para obtener una lista de indicadores con su id
    """
    response = await get_indicators_with_perspective(db)
    return response




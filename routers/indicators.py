from fastapi import APIRouter, Depends
from asyncpg import Connection
from services.indicator_service import fetch_indicator_value, get_indicators
from db.database import get_db

router = APIRouter(prefix="/indicators", tags=["indicators"])

@router.get("/indicators/{indicator_id}/aggregation/{aggregation_id}")
async def get_indicator_value_route(indicator_id: int, aggregation_id: int, start_date, end_date, db: Connection = Depends(get_db)):
    """
    API para obtener el valor de un indicador con una agregación específica.
    """
    response = await fetch_indicator_value(db, indicator_id, aggregation_id, start_date, end_date)
    return response

@router.get("/")
async def get_all_indicators(db: Connection = Depends(get_db)):
    """
    API para obtener una lista de indicadores con su id
    """
    response = await get_indicators(db)
    return response




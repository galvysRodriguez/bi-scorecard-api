from fastapi import APIRouter, Depends
from asyncpg import Connection
from services.indicator_service import fetch_indicator_value
from db.database import get_db

router = APIRouter(prefix="/indicators", tags=["indicators"])

@router.get("/indicators/{indicator_id}/aggregation/{aggregation_id}")
async def get_indicator_value_route(indicator_id: int, aggregation_id: int, db: Connection = Depends(get_db)):
    """
    API para obtener el valor de un indicador con una agregación específica.
    """
    response = await fetch_indicator_value(db, indicator_id, aggregation_id)
    return response



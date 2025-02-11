from fastapi import APIRouter, Depends
from asyncpg import Connection
from services.aggregation_service import get_aggregations
from db.database import get_db

router = APIRouter(prefix="/aggregations", tags=["agregations"])

@router.get("/")
async def get_all_aggregation(db: Connection = Depends(get_db)):
    """
    API para obtener las agregaciones con su id
    """
    return await get_aggregations(db)




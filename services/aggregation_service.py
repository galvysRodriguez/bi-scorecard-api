from asyncpg import Connection
from utils.api_response import api_response
from repositories.aggregation_repo import get_aggregations_query

async def get_aggregations(db: Connection):
    row = await get_aggregations_query(db)
    if not row:
        return api_response("aggregation not found", False)
    return api_response("Aggregations retrieved successfully", True, dict(row))
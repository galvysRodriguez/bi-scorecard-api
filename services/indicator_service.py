from asyncpg import Connection
from utils.api_response import api_response
from repositories.indicator_repo import get_indicator_query, get_indicators_query

async def fetch_indicator_value(db: Connection, indicator_id: int, aggregation_id: int):
    """
    Ejecuta la consulta SQL almacenada y aplica la función de agregación.
    """
    row = await get_indicator_query(db, indicator_id, aggregation_id)

    if not row:
        return {"message": "Indicator or aggregation not found", "status": False, "data": None, "error": "Not Found"}

    raw_query = row["consulta"]  # Consulta SQL base
    aggregation_function = row["funcion"]  # Función de agregación (ej. 'SUM')

    # Envolver la consulta base en un subquery con alias
    final_query = f"SELECT {aggregation_function}(subquery.value) AS result FROM ({raw_query}) AS subquery"

    try:
        result_row = await db.fetchrow(final_query)
        return {
            "message": "Indicator value retrieved",
            "status": True,
            "data": {"value": result_row["result"] if result_row else None},
            "error": ""
        }
    except Exception as e:
        return {
            "message": "Failed to execute query",
            "status": False,
            "data": None,
            "error": str(e)
        }


async def get_indicators(db: Connection):
    row = await get_indicators_query(db)
    if not row:
        return api_response("Indicator not found", False)
    return api_response("Indicators retrieved successfully", True, dict(row))
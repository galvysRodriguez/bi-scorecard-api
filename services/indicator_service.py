from asyncpg import Connection
from datetime import datetime
from utils.api_response import api_response
from repositories.indicator_repo import get_indicator_query, get_indicators_query, get_indicators_perspective_query, get_indicator_string_query

async def fetch_indicator_value(db: Connection, indicator_id: int, aggregation_id: int, start_date, end_date):
    """
    Ejecuta la consulta SQL almacenada y aplica la función de agregación.
    """
    row = await get_indicator_query(db, indicator_id, aggregation_id)

    if not row:
        return {"message": "Indicator or aggregation not found", "status": False, "data": None, "error": "Not Found"}

    raw_query = row["consulta"]  # Consulta SQL base
    aggregation_function = row["funcion"]  # Función de agregación (ej. 'SUM')


   

    filtered_query = f"""
        SELECT * FROM ({raw_query}) AS subquery
        WHERE subquery.fecha BETWEEN $1 AND $2
    """

    # Envolver la consulta base en un subquery con alias
    final_query = f"SELECT {aggregation_function}(subquery.value) AS result FROM ({filtered_query}) AS subquery"

    try:
        result_row = await db.fetchrow(final_query, start_date, end_date)
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

async def fetch_indicator(db: Connection, indicator:str, aggregation: str):
    """
    Ejecuta la consulta SQL almacenada y aplica la función de agregación.
    """
    row = await get_indicator_string_query(db, indicator)
    print(row)
    if not row:
        return {"message": "Indicator or aggregation not found", "status": False, "data": None, "error": "Not Found"}

    raw_query = row["consulta"]  # Consulta SQL base
    filtered_query = f"""SELECT * FROM ({raw_query}) AS subquery"""
    final_query = f"SELECT {aggregation}(subquery.value) AS result FROM ({filtered_query}) AS subquery"
    return await db.fetchrow(final_query)


async def fetch_indicator_str(db: Connection, indicator:str, aggregation: str, start_date, end_date):
    """
    Ejecuta la consulta SQL almacenada y aplica la función de agregación.
    """
    print(indicator, aggregation, start_date, end_date)
    row = await get_indicator_string_query(db, indicator)
    print(row)
    if not row:
        return {"message": "Indicator or aggregation not found", "status": False, "data": None, "error": "Not Found"}

    raw_query = row["consulta"]  # Consulta SQL base

    filtered_query = f"""
        SELECT * FROM ({raw_query}) AS subquery
        WHERE subquery.fecha BETWEEN $1 AND $2
    """

    final_query = f"SELECT {aggregation}(subquery.value) AS result FROM ({filtered_query}) AS subquery"
    response = await db.fetchrow(final_query, start_date, end_date)
    print(response)
    return response

async def get_indicators(db: Connection):
    row = await get_indicators_query(db)
    if not row:
        return api_response("Indicator not found", False)
    return api_response("Indicators retrieved successfully", True, dict(row))

async def get_indicators_perspective(db: Connection, perspective_id: int):
    row = await get_indicators_perspective_query(db, perspective_id)
    if not row:
        return api_response("Indicator not found", False)
    return api_response("Indicators retrieved successfully", True, dict(row))
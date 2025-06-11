from asyncpg import Connection
from repositories.reports.metric_repo import get_value_inventory, get_value_purchase, get_value_sale
from utils.api_response import api_response
from datetime import datetime, timedelta


async def get_value_service(db: Connection, date_from: str, date_to: str, warehouse: str):
    """Consulta el valor monetario del inventario por fecha"""

    try:
        start = datetime.strptime(date_from, "%Y-%m-%d")
        end = datetime.strptime(date_to, "%Y-%m-%d")
    except ValueError:
        return api_response("Invalid date format. Use YYYY-MM-DD.", False)

    full_days = (end - start).days + 1
    if full_days > 30:
        start = end - timedelta(days=29)

    start = start.date()
    end = end.date()

    value_inventory = await get_value_inventory(db, start, end, warehouse)
    value_sale = await get_value_sale(db, start, end, warehouse)
    value_purchase = await get_value_purchase(db, start, end, warehouse)
    
    rows ={
        "value_inventory": value_inventory,
        "value_sale": value_sale,
        "value_purchase": value_purchase
    }
    return api_response("metricas obtenidas correctamente", True, rows)
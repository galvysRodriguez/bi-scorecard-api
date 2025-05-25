from typing import Optional, List, Dict, Any
from fastapi import Depends
from asyncpg import Connection
from repositories.reports.warehouse_repo import get_simple_ids, get_grouped_data, get_filtered_moves_ids_by_columns, get_moves_ids_by_general_search, get_count_moves
from schemas.target import WarehouseFilter, ReportBase
from utils.api_response import api_response

async def get_response_warehouse(db: Connection, ids: Optional[List[int]], count: int = 0):
    if not ids:
        return api_response("Movimientos en depositos no conseguidos", False)
    grouped_data = await get_grouped_data(db, ids)
    

    response = {
        "data": grouped_data,  
        "total": count,  
    }
    #normalize_data = normalize_grouped_data(grouped_data)
    return api_response("Movimientos listados", True, response)

async def get_simple_warehouse(db: Connection, report_base: ReportBase):
    ids, count = await get_simple_ids(db, report_base)
    return await get_response_warehouse(db, ids, count)
    
async def get_filter_column_warehouse(
        db: Connection, 
        report_base: ReportBase,
        warehouse_filter: WarehouseFilter,
        search: Optional[str] = None,
        ):
    id = None
    if search:
        id = await get_moves_ids_by_general_search(db, search, report_base)
    
    ids, count = await get_filtered_moves_ids_by_columns(db, warehouse_filter, report_base, id)
    return await get_response_warehouse(db, ids, count)
    

async def get_search_column_warehouse(db: Connection, search:str, report_base: ReportBase):
    ids, count = await get_moves_ids_by_general_search(db, search, report_base)
    return await get_response_warehouse(db, ids, count)
    
def validation_order_by(order:str):
    valid_order_fields_map = {
        "id": "id",
        "warehouse": "deposito",
        "movement_type": "tipo_movimiento",
        "product_id": "id_productos",
        "product_name": "producto",
        "product_code": "codigo",
        "category": "categoria",
        "subcategory": "subcategoria",
        "product_type": "tipo_producto",
        "unit": "unidad",
        "brand": "marca",
        "product_details": "detalles",
        "product_presentations": "presentaciones",
        "quantity": "cantidad",
        "date": "fecha",
        "day": "dia",
        "weekday_number": "dia_semana",
        "weekday_name": "nombre_dia",
        "week_of_year": "semana_anio",
        "week_of_month": "semana_mes",
        "fortnight": "quincena",
        "month": "mes",
        "month_name": "nombre_mes",
        "quarter": "trimestre",
        "semester": "semestre",
        "year": "anio",
        "is_weekend": "es_fin_de_semana"
    }

    order_by = valid_order_fields_map.get(order)
    return order_by

def validation_order_dir(order:str):
    valid_order_dirs = {"asc", "desc"}
    order_dir = order.lower() if order.lower() in valid_order_dirs else None
    return order_dir

def normalize_grouped_data(rows: List[Dict[str, Any]]):
    grouped_result = []

    for row in rows:
        group_keys = {k: v for k, v in row.items() if v is not None and k not in ["total", "quantity"]}
        aggregate_values = {
            "total_movimientos": row.get("total", 0),
            "cantidad": row.get("quantity", 0)
        }

        grouped_result.append({
            "group_by": group_keys,
            "aggregates": aggregate_values
        })

    return grouped_result
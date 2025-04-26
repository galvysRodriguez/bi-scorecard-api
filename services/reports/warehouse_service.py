from typing import Optional, List, Dict, Any
from fastapi import Depends
from asyncpg import Connection
from repositories.reports.warehouse_repo import get_simple_ids, get_grouped_data, get_filtered_moves_ids_by_columns, get_moves_ids_by_general_search
from schemas.target import WarehouseFilter, ReportBase
from utils.api_response import api_response

async def get_respose_warehouse(db: Connection, ids: Optional[List[int]]):
    if not ids:
        return api_response("Movimientos en depositos no conseguidos", False)
    grouped_data = await get_grouped_data(db, ids)
    normalize_data = normalize_grouped_data(grouped_data)
    return api_response("Movimientos listados", True, normalize_data)

async def get_simple_warehouse(db: Connection, report_base: ReportBase):
    ids = await get_simple_ids(db, report_base)
    return await get_respose_warehouse(db, ids)
    
async def get_filter_column_warehouse(
        db: Connection, 
        report_base: ReportBase,
        warehouse_filter: WarehouseFilter,
        search: Optional[str] = None,
        ):
    id = None
    if search:
        id = await get_moves_ids_by_general_search(db, search, report_base)
    
    ids = await get_filtered_moves_ids_by_columns(db, warehouse_filter, report_base, id)
    return await get_respose_warehouse(db, ids)
    

async def get_search_column_warehouse(db: Connection, search:str, report_base: ReportBase):
    ids = await get_moves_ids_by_general_search(db, search, report_base)
    return await get_respose_warehouse(db, ids)
    
def validation_order_by(order:str):
    valid_order_fields_map = {
        "id": "id_movimientos",
        "date": "fecha",
        "quantity": "cantidad",
        "type": "tipo",
        "warehouse": "deposito",
        "product": "titulo"
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
        group_keys = {k: v for k, v in row.items() if v is not None and k not in ["total_movimientos", "cantidad"]}
        aggregate_values = {
            "total_movimientos": row.get("total_movimientos", 0),
            "cantidad": row.get("cantidad", 0)
        }

        grouped_result.append({
            "group_by": group_keys,
            "aggregates": aggregate_values
        })

    return grouped_result
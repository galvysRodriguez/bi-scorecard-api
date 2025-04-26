from fastapi import APIRouter, Depends, Query
from asyncpg import Connection
from typing import List, Optional
from services.reports.warehouse_service import get_simple_warehouse, get_search_column_warehouse, get_filter_column_warehouse, validation_order_by, validation_order_dir
from db.database import get_db
from schemas.target import WarehouseFilter, ReportBase
from utils.api_response import api_response

router = APIRouter(prefix="/reports/warehouse", tags=["/reports/warehouse"])

@router.get("/")
async def obtener_movimientos_grouped(
    warehouse: Optional[str] = None,
    type: Optional[str] = None,
    product: Optional[str] = None,
    date_min: Optional[str] = None,
    date_max: Optional[str] = None,
    quantity_min: Optional[int] = None,
    quantity_max: Optional[int] = None,
    order_by: Optional[str] = "id",
    order_dir: Optional[str] = "asc",
    limit: int = Query(10, ge=1, le=100),  
    offset: int = Query(0, ge=0),          
    search: Optional[str] = None,
    db: Connection = Depends(get_db)
):
    order_by = validation_order_by(order_by)
    if not order_by:
        return api_response("Columna a ordenar invalida", False)

    order_dir = validation_order_dir(order_dir)
    if not order_dir:
        return api_response("Direccion a ordenar invalida", False)

    report_base = ReportBase(
        order_by=order_by,
        order_dir=order_dir,
        limit=limit,
        offset=offset
    )
    if warehouse or type or product or date_min or date_max or quantity_min or quantity_max:
        filters = WarehouseFilter(
            warehouse=warehouse, 
            type=type, 
            product=product, 
            date_min=date_min,
            date_max=date_max,
            quantity_min=quantity_min,
            quantity_max=quantity_max
            )
        return await get_filter_column_warehouse(db, report_base, filters, search)
    if search:
        return await get_search_column_warehouse(db, search, report_base)
    return await get_simple_warehouse(db, report_base)
    
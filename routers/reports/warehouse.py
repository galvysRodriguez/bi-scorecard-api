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
    movement_type: Optional[str] = None,
    product_name: Optional[str] = None,
    product_code: Optional[str] = None,
    category: Optional[str] = None,
    subcategory: Optional[str] = None,
    product_type: Optional[str] = None,
    unit: Optional[str] = None,
    brand: Optional[str] = None,
    quantity_min: Optional[int] = None,
    quantity_max: Optional[int] = None,
    date_min: Optional[str] = None,
    date_max: Optional[str] = None,
    day: Optional[int] = None,
    weekday_number: Optional[int] = None,
    weekday_name: Optional[str] = None,
    week_of_year: Optional[int] = None,
    week_of_month: Optional[int] = None,
    fortnight: Optional[int] = None,
    month: Optional[int] = None,
    month_name: Optional[str] = None,
    quarter: Optional[int] = None,
    semester: Optional[int] = None,
    year: Optional[int] = None,
    is_weekend: Optional[bool] = None,
    search: Optional[str] = None,
    order_by: Optional[str] = "id",
    order_dir: Optional[str] = "asc",
    limit: int = Query(10, ge=1, le=10000),
    offset: int = Query(0, ge=0),
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

    filters = WarehouseFilter(
        warehouse=warehouse,
        movement_type=movement_type,
        product_name=product_name,
        product_code=product_code,
        category=category,
        subcategory=subcategory,
        product_type=product_type,
        unit=unit,
        brand=brand,
        quantity_min=quantity_min,
        quantity_max=quantity_max,
        date_min=date_min,
        date_max=date_max,
        day=day,
        weekday_number=weekday_number,
        weekday_name=weekday_name,
        week_of_year=week_of_year,
        week_of_month=week_of_month,
        fortnight=fortnight,
        month=month,
        month_name=month_name,
        quarter=quarter,
        semester=semester,
        year=year,
        is_weekend=is_weekend
    )

    # Función auxiliar para saber si hay algún filtro no vacío
    def has_filters(filter_obj: WarehouseFilter) -> bool:
        return any(
            value is not None
            for value in filter_obj.dict(exclude_none=True).values()
        )

    if has_filters(filters):
        return await get_filter_column_warehouse(db, report_base, filters, search)

    if search:
        return await get_search_column_warehouse(db, search, report_base)

    return await get_simple_warehouse(db, report_base)
    
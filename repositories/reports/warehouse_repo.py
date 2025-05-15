

from typing import List, Optional, Dict, Any
from asyncpg import Connection
from datetime import datetime
from repositories.reports.query_base import query_base_warehouse, query_base_warehouse_view
from schemas.target import WarehouseFilter, ReportBase

async def get_filtered_moves_ids_by_columns(
    db: Connection,
    warehouse_data: WarehouseFilter,
    report_base: ReportBase,
    ids: Optional[List[int]] = None,
) -> List[int]:
    conditions = []
    args = []
    index = 1

    def add_condition(condition: str, value):
        nonlocal index
        conditions.append(condition.replace("{}", f"${index}"))
        args.append(value)
        index += 1

    # Almacén
    if warehouse_data.warehouse:
        add_condition("deposito ILIKE {}", f"%{warehouse_data.warehouse}%")

    # Tipo de movimiento
    if warehouse_data.movement_type:
        add_condition("tipo_movimiento ILIKE {}", f"%{warehouse_data.movement_type}%")

    # Producto
    if warehouse_data.product_name:
        add_condition("titulo ILIKE {}", f"%{warehouse_data.product_name}%")
    if warehouse_data.product_code:
        add_condition("codigo ILIKE {}", f"%{warehouse_data.product_code}%")
    if warehouse_data.category:
        add_condition("categoria ILIKE {}", f"%{warehouse_data.category}%")
    if warehouse_data.subcategory:
        add_condition("subcategoria ILIKE {}", f"%{warehouse_data.subcategory}%")
    if warehouse_data.product_type:
        add_condition("tipo_producto ILIKE {}", f"%{warehouse_data.product_type}%")
    if warehouse_data.unit:
        add_condition("unidad ILIKE {}", f"%{warehouse_data.unit}%")
    if warehouse_data.brand:
        add_condition("marca ILIKE {}", f"%{warehouse_data.brand}%")
    if warehouse_data.product_id:
        add_condition("id_productos = {}", warehouse_data.product_id)

    # Cantidad
    if warehouse_data.quantity_min is not None:
        add_condition("cantidad >= {}", warehouse_data.quantity_min)
    if warehouse_data.quantity_max is not None:
        add_condition("cantidad <= {}", warehouse_data.quantity_max)

    # Fechas
    if warehouse_data.date_min:
        date_obj = datetime.strptime(warehouse_data.date_min, "%Y-%m-%d").date()
        add_condition("DATE(m.fecha) >= {}", date_obj)
    if warehouse_data.date_max:
        date_obj = datetime.strptime(warehouse_data.date_max, "%Y-%m-%d").date()
        add_condition("DATE(m.fecha) <= {}", date_obj)

    # Atributos del calendario
    if warehouse_data.day:
        add_condition("dia = {}", warehouse_data.day)
    if warehouse_data.weekday_number:
        add_condition("dia_semana = {}", warehouse_data.weekday_number)
    if warehouse_data.weekday_name:
        add_condition("nombre_dia ILIKE {}", f"%{warehouse_data.weekday_name}%")
    if warehouse_data.week_of_year:
        add_condition("semana_anio = {}", warehouse_data.week_of_year)
    if warehouse_data.week_of_month:
        add_condition("semana_mes = {}", warehouse_data.week_of_month)
    if warehouse_data.fortnight:
        add_condition("quincena = {}", warehouse_data.fortnight)
    if warehouse_data.month:
        add_condition("mes = {}", warehouse_data.month)
    if warehouse_data.month_name:
        add_condition("nombre_mes ILIKE {}", f"%{warehouse_data.month_name}%")
    if warehouse_data.quarter:
        add_condition("trimestre = {}", warehouse_data.quarter)
    if warehouse_data.semester:
        add_condition("semestre = {}", warehouse_data.semester)
    if warehouse_data.year:
        add_condition("anio = {}", warehouse_data.year)
    if warehouse_data.is_weekend is not None:
        add_condition("es_fin_de_semana = {}", warehouse_data.is_weekend)
        
    if ids:
        add_condition("id = ANY({})", ids)

    where_clause = f"WHERE {' AND '.join(conditions)}" if conditions else ""

    args.extend([report_base.limit, report_base.offset])
    query = f"""
    {query_base_warehouse_view}
    {where_clause}
    ORDER BY {report_base.order_by} {report_base.order_dir.upper()}
    LIMIT ${index} OFFSET ${index + 1}
    """

    rows = await db.fetch(query, *args)
    return [row["id"] for row in rows]

async def get_grouped_data(db: Connection, ids: List[int]):
    query = f"""
    WITH movimientos_filtrados AS (
        {query_base_warehouse_view}
        WHERE id = ANY($1)
    )
    SELECT 
      *
    FROM movimientos_filtrados
    """
    return await db.fetch(query, ids)

async def get_simple_ids(db: Connection, report_base: ReportBase):
    query = f"""
        {query_base_warehouse}
        ORDER BY {report_base.order_by} {report_base.order_dir.upper()}
        LIMIT $1 OFFSET $2
    """
    rows = await db.fetch(query, report_base.limit, report_base.offset)
    return [row["id"] for row in rows]

async def get_moves_ids_by_general_search(
    db: Connection,
    search: str,
    report_base: ReportBase
) -> List[int]:
    search_pattern = f"%{search}%"

    query = f"""
    {query_base_warehouse_view}
    WHERE 
        deposito ILIKE $1 OR 
        tipo_movimiento ILIKE $1 OR 
        producto ILIKE $1 OR
        codigo ILIKE $1 OR
        marca ILIKE $1 OR
        categoria ILIKE $1 OR
        subcategoria ILIKE $1 OR
        nombre_dia ILIKE $1 OR
        nombre_mes ILIKE $1
    ORDER BY {report_base.order_by} {report_base.order_dir.upper()}
    LIMIT $2 OFFSET $3
    """

    rows = await db.fetch(query, search_pattern, report_base.limit, report_base.offset)
    return [row["id"] for row in rows]

async def get_count_moves(db: Connection):
    query = f"""
    SELECT COUNT(*) as count
    FROM almacenes.movimientos
    """
    row = await db.fetchrow(query)
    return row["count"] if row else 0


from typing import List, Optional, Dict, Any
from asyncpg import Connection
from datetime import datetime
from repositories.reports.query_base import query_base_warehouse
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

    if warehouse_data.warehouse:
        conditions.append(f"d.deposito ILIKE ${index}")
        args.append(f"%{warehouse_data.warehouse}%")
        index += 1

    if warehouse_data.type:
        conditions.append(f"tm.tipo ILIKE ${index}")
        args.append(f"%{warehouse_data.type}%")
        index += 1

    if warehouse_data.product:
        conditions.append(f"p.titulo ILIKE ${index}")
        args.append(f"%{warehouse_data.product}%")
        index += 1

    if warehouse_data.date_min:
        date_obj = datetime.strptime(warehouse_data.date_min, "%Y-%m-%d").date()
        conditions.append(f"DATE(m.fecha) >= ${index}")
        args.append(date_obj)
        index += 1

    if warehouse_data.date_max:
        date_obj = datetime.strptime(warehouse_data.date_max, "%Y-%m-%d").date()
        conditions.append(f"DATE(m.fecha) <= ${index}")
        args.append(date_obj)
        index += 1

    if warehouse_data.quantity_min is not None:
        conditions.append(f"m.cantidad >= ${index}")
        args.append(warehouse_data.quantity_min)
        index += 1

    if warehouse_data.quantity_max is not None:
        conditions.append(f"m.cantidad <= ${index}")
        args.append(warehouse_data.quantity_max)
        index += 1

    if ids:
        conditions.append(f"m.id_movimientos = ANY(${index})")
        args.append(ids) 
        index += 1

    where_clause = f"WHERE {' AND '.join(conditions)}" if conditions else ""

    args.extend([report_base.limit, report_base.offset])
    query = f"""
    {query_base_warehouse}
    {where_clause}
    ORDER BY {report_base.order_by} {report_base.order_dir.upper()}
    LIMIT ${index} OFFSET ${index + 1}
    """

    rows = await db.fetch(query, *args)
    return [row["id_movimientos"] for row in rows]


async def get_grouped_data(db: Connection, ids: List[int]):
    query = f"""
    WITH movimientos_filtrados AS (
        SELECT *
        FROM almacenes.movimientos
        WHERE id_movimientos = ANY($1)
    )
    SELECT 
      m.id_movimientos,
      d.deposito,
      tm.tipo,
      p.titulo,
      COUNT(*) AS total_movimientos,
      SUM(m.cantidad) AS cantidad,
      m.fecha
    FROM movimientos_filtrados m
    INNER JOIN almacenes.depositos d ON d.id_depositos = m.id_depositos 
    INNER JOIN almacenes.tipo_movimientos tm ON tm.id_tipo_movimientos = m.id_tipo_movimientos 
    INNER JOIN productos.productos p ON p.id_productos = m.id_productos 
    GROUP BY GROUPING SETS (
      (p.titulo),
      (d.deposito),
      (tm.tipo),
      (p.titulo, d.deposito),
      (p.titulo, tm.tipo),
      (d.deposito, tm.tipo),
      (d.deposito, tm.tipo, p.titulo),
      (p.titulo, m.fecha),
      (d.deposito, m.fecha),
      (tm.tipo, m.fecha),
      (p.titulo, d.deposito, m.fecha),
      (p.titulo, tm.tipo, m.fecha),
      (d.deposito, tm.tipo, m.fecha),
      (d.deposito, tm.tipo, p.titulo, m.fecha),
      (m.id_movimientos, d.deposito, tm.tipo, p.titulo, m.fecha)
    )
    """
    return await db.fetch(query, ids)

async def get_simple_ids(db: Connection, report_base: ReportBase):
    query = f"""
        SELECT id_movimientos
        FROM almacenes.movimientos
        ORDER BY {report_base.order_by} {report_base.order_dir.upper()}
        LIMIT $1 OFFSET $2
    """
    rows = await db.fetch(query, report_base.limit, report_base.offset)
    return [row["id_movimientos"] for row in rows]

async def get_moves_ids_by_general_search(db: Connection, search: str, report_base: ReportBase):
    search_pattern = f"{search}%"

    query = f"""
    {query_base_warehouse}
    WHERE 
        d.deposito ILIKE $1 OR 
        tm.tipo ILIKE $1 OR 
        p.titulo ILIKE $1
    ORDER BY {report_base.order_by} {report_base.order_dir.upper()}
    LIMIT $2 OFFSET $3
    """
    
    rows = await db.fetch(query, search_pattern, report_base.limit, report_base.offset)
    return [row["id_movimientos"] for row in rows]

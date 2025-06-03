

from typing import List, Optional, Dict, Any
from asyncpg import Connection
from datetime import datetime
from repositories.reports.query_base import  query_base_quote_view, where_clause_quote_general
from schemas.target import QuoteFilter, ReportBase
from repositories.reports.filter_base import build_quote_filters

async def get_filtered_quote_ids_by_columns(
    db: Connection,
    quote_data: QuoteFilter,
    report_base: ReportBase,
    ids: Optional[List[int]] = None,
) -> List[int]:
    where_clause, values, index = build_quote_filters(quote_data, ids)

    values.extend([report_base.limit, report_base.offset])
    query = f"""
    {query_base_quote_view}
    {where_clause}
    ORDER BY {report_base.order_by} {report_base.order_dir.upper()}
    LIMIT ${index} OFFSET ${index + 1}
    """

    query_count = f"""
    SELECT COUNT(*) as count
    FROM ventas.vw_cotizaciones
    {where_clause}
    """

    rows = await db.fetch(query, *values)
    count = await db.fetchrow(query_count, *values[:-2])
    return [row["id"] for row in rows], count["count"]

async def get_grouped_data(db: Connection, ids: List[int], report_base:ReportBase):
    query = f"""
    WITH movimientos_filtrados AS (
        {query_base_quote_view}
        WHERE id = ANY($1)
        ORDER BY {report_base.order_by} {report_base.order_dir.upper()}
    )
    SELECT 
      *
    FROM movimientos_filtrados
    """
    return await db.fetch(query, ids)

async def get_simple_ids(db: Connection, report_base: ReportBase):
    query = f"""
        {query_base_quote_view}
        ORDER BY {report_base.order_by} {report_base.order_dir.upper()}
        LIMIT $1 OFFSET $2
    """
    query_count = f"""
    SELECT COUNT(*) as count
    FROM ventas.vw_cotizaciones
    """
    rows = await db.fetch(query, report_base.limit, report_base.offset)
    count = await db.fetchrow(query_count)
    return [row["id"] for row in rows], count["count"]

async def get_quote_ids_by_general_search(
    db: Connection,
    search: str,
    report_base: ReportBase
) -> List[int]:
    search_pattern = f"%{search}%"

    query = f"""
    {query_base_quote_view}
    {where_clause_quote_general}
    ORDER BY {report_base.order_by} {report_base.order_dir.upper()}
    LIMIT $2 OFFSET $3
    """

    query_count = f"""
    SELECT COUNT(*) as count
    FROM ventas.vw_cotizaciones
    {where_clause_quote_general}
    """

    rows = await db.fetch(query, search_pattern, report_base.limit, report_base.offset)
    count = await db.fetchrow(query_count, search_pattern)
    return [row["id"] for row in rows], count["count"]
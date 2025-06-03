import pytest
from asyncpg import Connection
from schemas.target import ReportBase, WarehouseFilter
from repositories.reports.warehouse_repo import get_filtered_moves_ids_by_columns, get_grouped_data, get_moves_ids_by_general_search, get_simple_ids
from db.test_database import get_db

@pytest.mark.asyncio
async def test_get_grouped_data():
    db = await get_db()  
    result = await get_grouped_data(db, [1,2,3])
    assert len(result) == 3
    assert result[2]["quantity"] == 10
    assert result[0]["movement_type"] == "COMPRA"
    assert result[1]["movement_type"] == "AJUSTE DE INVENTARIO"
    await db.close()  

@pytest.mark.asyncio
async def test_get_simple_ids():
    db = await get_db()  
    report = ReportBase(limit=10, offset=0, order_by="id", order_dir="ASC")
    ids, total = await get_simple_ids(db, report)  
    assert ids[0] == 1
    assert ids[6] == 7
    await db.close()  

@pytest.mark.asyncio
async def test_get_search_ids():
    db = await get_db()  
    report = ReportBase(limit=100, offset=0, order_by="id", order_dir="ASC")
    search = "ATAMEL"
    result, total = await get_moves_ids_by_general_search(db, search, report)
    assert len(result) == 21
    await db.close()  

@pytest.mark.asyncio
async def test_get_filter_ids():
    db = await get_db()  
    report = ReportBase(limit=100, offset=0, order_by="id", order_dir="ASC")
    filter = WarehouseFilter(product_name="ATAMEL")
    result, total = await get_filtered_moves_ids_by_columns(db, filter, report)
    assert len(result) == 21
    await db.close()  

@pytest.mark.asyncio
async def test_get_filter_ids_max():
    db = await get_db()  
    report = ReportBase(limit=10, offset=0, order_by="id", order_dir="ASC")
    filter = WarehouseFilter(quantity_min=50, movement_type='CARGO')
    result, total = await get_filtered_moves_ids_by_columns(db, filter, report)
    assert len(result) == 5
    await db.close()  

@pytest.mark.asyncio
async def test_get_filter_ids_date():
    db = await get_db()  
    report = ReportBase(limit=10, offset=0, order_by="id", order_dir="ASC")
    filter = WarehouseFilter(quantity_max=10, warehouse="DEPOSITO DISTRIBUIDOR", date_min="2024-06-10", date_max="2024-06-10")
    result, total = await get_filtered_moves_ids_by_columns(db, filter, report)
    assert len(result) == 6
    await db.close()  
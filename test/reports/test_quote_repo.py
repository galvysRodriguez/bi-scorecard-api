import pytest
from asyncpg import Connection
from schemas.target import ReportBase, QuoteFilter
from repositories.reports.quote_repo import get_filtered_quote_ids_by_columns, get_grouped_data, get_quote_ids_by_general_search, get_simple_ids
from db.test_database import get_db

@pytest.mark.asyncio
async def test_get_grouped_data():
    db = await get_db()  
    result = await get_grouped_data(db, [1,2,3])
    assert len(result) == 3
    assert result[2]["quantity"] == 1
    assert result[0]["quantity"] == 12
    await db.close()  

@pytest.mark.asyncio
async def test_get_simple_ids():
    db = await get_db()  
    report = ReportBase(limit=10, offset=0, order_by="id", order_dir="ASC")
    ids, total = await get_simple_ids(db, report)  
    assert ids[0] == 1
    assert ids[4] == 7
    await db.close()  

@pytest.mark.asyncio
async def test_get_search_ids():
    db = await get_db()  
    report = ReportBase(limit=100, offset=0, order_by="id", order_dir="ASC")
    search = "HARINA DE TRIGO"
    result, total = await get_quote_ids_by_general_search(db, search, report)
    assert len(result) == 1
    await db.close()  

@pytest.mark.asyncio
async def test_get_filter_ids():
    db = await get_db()  
    report = ReportBase(limit=100, offset=0, order_by="id", order_dir="ASC")
    filter = QuoteFilter(product_name="HARINA DE TRIGO")
    result, total = await get_filtered_quote_ids_by_columns(db, filter, report)
    assert len(result) == 1
    await db.close()  

@pytest.mark.asyncio
async def test_get_filter_ids_max():
    db = await get_db()  
    report = ReportBase(limit=10, offset=0, order_by="id", order_dir="ASC")
    filter = QuoteFilter(quantity_min=20)
    result, total = await get_filtered_quote_ids_by_columns(db, filter, report)
    assert len(result) == 3
    await db.close()  

@pytest.mark.asyncio
async def test_get_filter_ids_date():
    db = await get_db()  
    report = ReportBase(limit=10, offset=0, order_by="id", order_dir="ASC")
    filter = QuoteFilter(quantity_min=2, warehouse="DEPOSITO DISTRIBUIDOR", date_min="2024-05-10", date_max="2024-06-10")
    result, total = await get_filtered_quote_ids_by_columns(db, filter, report)
    assert len(result) == 1
    await db.close()  
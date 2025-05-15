from fastapi import APIRouter
from datetime import datetime, timedelta
from etl.db.bi import destination_engine
from utils.api_response_etl import api_response_etl
from etl.view.purcharse_view import create_view_purchase_db, delete_view_purchase_db
from etl.view.order_view import create_view_order_db, delete_view_order_db
from etl.view.product_view import create_view_product_db, delete_view_product_db
from etl.view.sale_view import create_view_sale_db, delete_view_sale_db
from etl.view.quote_view import create_view_quote_db, delete_view_quote_db
from etl.view.warehouse_view import create_view_warehouse_db, delete_view_warehouse_db

router = APIRouter(prefix="/etl/view", tags=["etl/view"])

@router.post("/purchase")
async def create_vw_purchase():
    end = datetime.now()
    await create_view_purchase_db(destination_engine)
    start = end - timedelta(days=1)
    return api_response_etl("Creacion de triggers ha sido completada", start, end)

@router.delete("/purchase")
async def create_vw_purchase():
    end = datetime.now()
    await delete_view_purchase_db(destination_engine)
    start = end - timedelta(days=1)
    return api_response_etl("Creacion de triggers ha sido completada", start, end)

@router.post("/order")
async def create_vw_order():
    end = datetime.now()
    await create_view_order_db(destination_engine)
    start = end - timedelta(days=1)
    return api_response_etl("Creacion de triggers ha sido completada", start, end)

@router.delete("/order")
async def create_vw_order():
    end = datetime.now()
    await delete_view_order_db(destination_engine)
    start = end - timedelta(days=1)
    return api_response_etl("Creacion de triggers ha sido completada", start, end)


@router.post("/product")
async def create_vw_product():
    end = datetime.now()
    await create_view_product_db(destination_engine)
    start = end - timedelta(days=1)
    return api_response_etl("Creacion de triggers ha sido completada", start, end)

@router.delete("/product")
async def create_vw_product():
    end = datetime.now()
    await delete_view_product_db(destination_engine)
    start = end - timedelta(days=1)
    return api_response_etl("Creacion de triggers ha sido completada", start, end)

@router.post("/sale")
async def create_vw_sale():
    end = datetime.now()
    await create_view_sale_db(destination_engine)
    start = end - timedelta(days=1)
    return api_response_etl("Creacion de triggers ha sido completada", start, end)

@router.delete("/sale")
async def create_vw_sale():
    end = datetime.now()
    await delete_view_sale_db(destination_engine)
    start = end - timedelta(days=1)
    return api_response_etl("Creacion de triggers ha sido completada", start, end)

@router.post("/quote")
async def create_vw_quote():
    end = datetime.now()
    await create_view_quote_db(destination_engine)
    start = end - timedelta(days=1)
    return api_response_etl("Creacion de triggers ha sido completada", start, end)

@router.delete("/quote")
async def create_vw_quote():
    end = datetime.now()
    await delete_view_quote_db(destination_engine)
    start = end - timedelta(days=1)
    return api_response_etl("Creacion de triggers ha sido completada", start, end)

@router.post("/warehouse")
async def create_vw_warehouse():
    end = datetime.now()
    await create_view_warehouse_db(destination_engine)
    start = end - timedelta(days=1)
    return api_response_etl("Creacion de triggers ha sido completada", start, end)

@router.delete("/warehouse")
async def create_vw_warehouse():
    end = datetime.now()
    await delete_view_warehouse_db(destination_engine)
    start = end - timedelta(days=1)
    return api_response_etl("Creacion de triggers ha sido completada", start, end)




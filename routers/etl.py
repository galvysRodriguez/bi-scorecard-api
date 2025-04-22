from fastapi import APIRouter, Body
from datetime import datetime, timedelta
from typing import Optional, List, Literal
from etl.db.erp import source_engine
from etl.db.bi import destination_engine
from etl.table_config import TABLE_PROCESS
from etl.logs.main import run_create_triggers_logs
from etl.logs.tables import TABLES
from utils.api_response_etl import api_response_etl
from etl.main import run_extract_table, run_sync_table
from etl.json.clear import clear_destination_db
from etl.json.resources import create_resources_db, delete_resources_db
from schemas.target import TableProcessSchema
from etl.backup.backup import backup_mysql, backup_postgresql

router = APIRouter(prefix="/etl", tags=["etl"])

@router.post("/logs")
async def create_triggers_logs(tables: Optional[List[str]] = None):
    end = datetime.now()
    tables_to_process = tables or TABLES
    await run_create_triggers_logs(source_engine, tables_to_process)
    start = end - timedelta(days=1)
    return api_response_etl("Creacion de triggers ha sido completada", start, end, tables_to_process)

@router.post("/extract")
async def extract_table_all(table_process: Optional[TableProcessSchema] = None):
    end = datetime.now()
    tables_to_process = table_process or TABLE_PROCESS
    await run_extract_table(source_engine, destination_engine, tables_to_process)
    start = end - timedelta(days=1)
    return api_response_etl("La extraccion ha sido completada", start, end, tables_to_process)

@router.post("/sync")
async def sync_table_logs(table_process: Optional[TableProcessSchema] = None):
    end = datetime.now()
    tables_to_process = table_process or TABLE_PROCESS
    await run_sync_table(source_engine, destination_engine, tables_to_process)
    start = end - timedelta(days=1)
    return api_response_etl("La sincronizacion ha sido completada", start, end, tables_to_process)

@router.post("/clear")
async def delete_table_all(tables: Optional[List[str]] = None):
    end = datetime.now()
    await clear_destination_db(destination_engine)
    start = end - timedelta(days=1)
    return api_response_etl("La eliminacion ha sido completada", start, end, tables or [])

@router.post("/resource")
async def create_resources_all(tables: Optional[List[str]] = None):
    end = datetime.now()
    await create_resources_db(source_engine)
    start = end - timedelta(days=1)
    return api_response_etl("La creacion de recursos ha sido completada", start, end, tables or [])

@router.post("/resource/delete")
async def delete_resources_bi():
    end = datetime.now()
    await delete_resources_db(source_engine)
    start = end - timedelta(days=1)
    return api_response_etl("La eliminacion de recursos ha sido completada", start, end)

@router.post("/backup")
async def create_backup_engine(engine: Literal["source", "destination", "all"] = Body(..., embed=True)):
    end = datetime.now()
    if engine == "source":
        await backup_mysql()
        start = end - timedelta(days=1)
        return api_response_etl("La creacion de recursos ha sido completada", start, end)
    await backup_postgresql()
    start = end - timedelta(days=1)
    return api_response_etl("La creacion de recursos ha sido completada", start, end)
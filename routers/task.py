from fastapi import APIRouter
from apscheduler.schedulers.asyncio import AsyncIOScheduler
from routers.etl import sync_table_logs
import asyncio

router = APIRouter(prefix="/task", tags=["task"])

scheduler = AsyncIOScheduler()

async def schedule_etl():
    print("Ejecución automática del ETL iniciada.")
    await sync_table_logs()
    print("ETL finalizado automáticamente.")

scheduler.add_job(schedule_etl, 'interval', hours=2)
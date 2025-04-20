from etl.extract_table import extract_table
from etl.sync_table import sync_table

last_log_ids = {}

async def run_extract_table(source_engine, destination_engine, TABLE_PROCESS):
    for table_config in TABLE_PROCESS:
        await extract_table(table_config, source_engine, destination_engine)

async def run_sync_table(source_engine, destination_engine, TABLE_PROCESS):
    for table_config in TABLE_PROCESS:
        await sync_table(table_config, source_engine, destination_engine, last_log_ids)
from etl.logs.logs_manager import create_table_logs
from etl.logs.trigger_manager import create_triggers


async def run_create_triggers_logs(source_engine, TABLES):
    create_table_logs(source_engine)
    for table in TABLES:
        create_triggers(source_engine, table)

    
    


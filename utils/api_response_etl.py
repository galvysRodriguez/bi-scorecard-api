import datetime

def api_response_etl(message: str, start: datetime, end: datetime, table: str = ""):
    return {
        "message": message,
        "start": str(start),
        "end": str(end),
        "tables": table
    }

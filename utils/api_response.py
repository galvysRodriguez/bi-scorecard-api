from typing import Any

def api_response(message: str, status: bool, data: Any = None, error: str = ""):
    return {
        "message": message,
        "status": status,
        "data": data if data is not None else [],
        "error": error
    }

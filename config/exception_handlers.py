from fastapi import Request, HTTPException
from fastapi.responses import JSONResponse
import logging


async def http_exception_handler(request: Request, exc: HTTPException):
    if exc.status_code == 401:
        message = "No estás autenticado. Por favor, inicia sesión."
    elif exc.status_code == 403:
        message = "No tienes permisos para acceder a este recurso."
    else:
        message = f"Error {exc.status_code}: {exc.detail}"

    return JSONResponse(
        status_code=exc.status_code,
        content={"message": message}
    )

async def unhandled_exception_handler(request: Request, exc: Exception):
    logging.error(f"Unhandled error: {exc}")
    return JSONResponse(
        status_code=500,
        content={"message": "Ocurrió un error inesperado en el servidor"},
    )
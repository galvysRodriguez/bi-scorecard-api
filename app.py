# Punto de entrada para Vercel: si main.py falla al importar, responde con el traceback para poder diagnosticarlo
import traceback

try:
    from main import app
except Exception:
    _traceback = traceback.format_exc()
    print(_traceback)

    async def app(scope, receive, send):
        if scope["type"] != "http":
            return
        await send({
            "type": "http.response.start",
            "status": 500,
            "headers": [(b"content-type", b"text/plain; charset=utf-8"), (b"access-control-allow-origin", b"*")],
        })
        await send({"type": "http.response.body", "body": _traceback.encode()})

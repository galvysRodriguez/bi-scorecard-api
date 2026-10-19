import os
from urllib.parse import urlsplit, urlunsplit, parse_qsl, urlencode

import asyncpg
from dotenv import load_dotenv

load_dotenv()

def _asyncpg_dsn(url: str) -> str:
    # asyncpg no soporta channel_binding (lo envia como parametro del servidor y Postgres lo rechaza)
    parts = urlsplit(url)
    query = [(k, v) for k, v in parse_qsl(parts.query) if k != "channel_binding"]
    return urlunsplit(parts._replace(query=urlencode(query)))

DATABASE_URL = _asyncpg_dsn(os.getenv("DATABASE_URL", "postgresql://postgres:olap22@localhost/postgres"))

async def get_db():
    return await asyncpg.connect(DATABASE_URL)

import os

import asyncpg
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:olap22@localhost/postgres")

async def get_db():
    return await asyncpg.connect(DATABASE_URL)

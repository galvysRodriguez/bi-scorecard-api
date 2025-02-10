# database.py
import asyncpg
from fastapi import Depends

#DATABASE_URL = "postgresql://neondb_owner:zA14aVFdZOuW@ep-green-credit-a7hk2zpx.ap-southeast-2.aws.neon.tech/neondb?sslmode=require"
DATABASE_URL = "postgresql://postgres:olap22@localhost/postgres"

async def get_db():
    return await asyncpg.connect(DATABASE_URL)

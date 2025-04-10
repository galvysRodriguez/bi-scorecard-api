import pytest
import asyncpg
import os
from asyncpg import Connection

DATABASE_URL = "postgresql://postgres:olap22@localhost/postgres"

@pytest.fixture
async def db_connection():
    # Configura la conexión con tu URL real
    conn = await asyncpg.connect(DATABASE_URL)
    
    # Inicia transacción para aislamiento de pruebas
    transaction = conn.transaction()
    await transaction.start()
    
    yield conn
    
    # Limpieza - rollback para deshacer cambios
    await transaction.rollback()
    await conn.close()
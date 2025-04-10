import pytest
from asyncpg import Connection
from repositories.target_repo import TargetRepository
from db.database import get_db

@pytest.mark.asyncio
async def test_target_perspective_len():
    db = await get_db()  
    result = await TargetRepository.get_targets(db, 1)
    assert len(result) == 16
    await db.close()  

@pytest.mark.asyncio
async def test_target_by_id_true():
    db = await get_db()  
    result = await TargetRepository.get_target(db, 6)
    assert result["title"] == "Compras"
    await db.close()  
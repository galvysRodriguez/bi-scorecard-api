import pytest
from asyncpg import Connection
from repositories.target_repo import TargetRepository
from db.database import get_db
from schemas.target import TargetBase

@pytest.mark.asyncio
async def test_target_perspective_len():
    db = await get_db()  
    result = await TargetRepository.get_targets(db, 1)
    assert len(result) == 17
    await db.close()  

@pytest.mark.asyncio
async def test_target_by_id_true():
    db = await get_db()  
    result = await TargetRepository.get_target(db, 6)
    assert result["title"] == "Compras"
    await db.close()  

@pytest.mark.asyncio
async def test_target_exist_true():
    db = await get_db()  
    formula = TargetBase(title="vida util")
    result = await TargetRepository.exist_target(db, formula)
    assert result["count"] == 1, "Debería encontrar 1 registro existente"
    await db.close()  

@pytest.mark.asyncio
async def test_target_exist_update_false():
    db = await get_db()  
    formula = TargetBase(title="vida util nn")
    result = await TargetRepository.exist_target_update(db, 35, formula)
    assert result["count"] == 0, "Debería encontrar 0 registro existente"
    await db.close()  
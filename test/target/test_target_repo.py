import pytest
from asyncpg import Connection
from repositories.target_repo import TargetRepository
from db.database import get_db
from schemas.target import TargetBase, TargetCreate

@pytest.mark.asyncio
async def test_target_perspective_len():
    db = await get_db()  
    result = await TargetRepository.get_targets(db, 1)
    assert len(result) == 18
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
    target = TargetBase(title="vida util")
    result = await TargetRepository.exist_target(db, target)
    assert result["count"] == 1, "Debería encontrar 1 registro existente"
    await db.close()  

@pytest.mark.asyncio
async def test_target_exist_update_false():
    db = await get_db()  
    target = TargetBase(title="vida util nn")
    result = await TargetRepository.exist_target_update(db, 35, target)
    assert result["count"] == 0, "Debería encontrar 0 registro existente"
    await db.close()  

@pytest.mark.asyncio
async def test_target_exist_update_true():
    db = await get_db()  
    target = TargetBase(title="vida util nn")
    result = await TargetRepository.exist_target_update(db, 38, target)
    assert result["count"] == 1, "Debería encontrar 0 registro existente"
    await db.close()  

@pytest.mark.asyncio
async def test_target_verify_update_object():
    db = await get_db()  
    target_id = 35
    target = TargetCreate(title="vida util nn", optimal=2222, tolerable=222, 
                           deficient=111, start_date="2023-01-01", end_date="2023-12-31", 
                           formula_id=20)
    result = await TargetRepository.update_target(db, target_id, target)
    assert result["id_formulas"] == 20
    assert result["titulo"] == "vida util nn"
    assert result["optimo"] == 2222
    await db.close()  
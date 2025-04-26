import pytest
from asyncpg import Connection
from schemas.target import FormulaBase
from repositories.formula_repo import exist_formula_query, exist_formula_update_query
from db.test_database import get_db

@pytest.mark.asyncio
async def test_exist_formula_true():
    db = await get_db()  
    formula = FormulaBase(title="Clientes nuevos")
    result = await exist_formula_query(db, formula)
    assert result["count"] == 1, "Debería encontrar 1 registro existente"
    await db.close()  

@pytest.mark.asyncio
async def test_exist_formula_false():
    db = await get_db()  
    formula = FormulaBase(title="NoExistente123")
    result = await exist_formula_query(db, formula)  
    assert result["count"] == 0, "No debería encontrar registros"
    await db.close()  

@pytest.mark.asyncio
async def test_target_exist_update_false():
    db = await get_db()  
    formula = FormulaBase(title="Clientes nuevos")
    result = await exist_formula_update_query(db, 20, formula)
    assert result["count"] == 0, "Debería encontrar 0 registro existente"
    await db.close()  
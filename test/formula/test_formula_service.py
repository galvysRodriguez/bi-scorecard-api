# test/formula/test_formula_repo.py
import pytest
from asyncpg import Connection
from schemas.target import FormulaBase
from services.formula_service import exist_formula

@pytest.mark.asyncio
async def test_exist_formula_with_real_db(db_connection: Connection):
    # Datos de prueba
    test_data = FormulaBase(title="Compras")
    
    # Ejecución
    result = await exist_formula(db_connection, test_data)
    
    # Aserciones
    assert result["success"] is True
    assert isinstance(result["data"], dict)
    assert "count" in result["data"]
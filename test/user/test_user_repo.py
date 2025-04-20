import pytest
from schemas.target import UserBase
from repositories.user_repo import login_query
from db.database import get_db

@pytest.mark.asyncio
async def test_exist_user_true():
    db = await get_db()  
    user = UserBase(username="admin", hashed_password="123456")
    result = await login_query(db, user)
    assert result["nombre"] == "Super", "Debería encontrar 1 registro existente"
    await db.close()  
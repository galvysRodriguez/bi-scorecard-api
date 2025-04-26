import pytest
from schemas.target import UserBase
from repositories.user_repo import login_query, verify_permission_role_query, get_permissions_by_role
from db.test_database import get_db

@pytest.mark.asyncio
async def test_exist_user_true():
    db = await get_db()  
    user = UserBase(username="admin", hashed_password="123456")
    result = await login_query(db, user)
    assert result["name"] == "Super", "Debería encontrar 1 registro existente"
    await db.close()  

@pytest.mark.asyncio
async def test_exist_user_false():
    db = await get_db()  
    user = UserBase(username="admin2", hashed_password="123456")
    result = await login_query(db, user)
    assert result is None, "Debería encontrar 0 registro existente"
    await db.close()  

@pytest.mark.asyncio
async def test_user_verify_permission_true():
    db = await get_db()  
    result = await verify_permission_role_query(db, 3, '/formula', 'GET')
    assert result is not None, "Debería encontrar 1 registro existente"
    await db.close()  

@pytest.mark.asyncio
async def test_user_verify_permission_not_found():
    db = await get_db()  
    result = await verify_permission_role_query(db, 300, '/formula', 'GET')
    assert result is None, "Debería encontrar 0 registro existente"
    await db.close()  


@pytest.mark.asyncio
async def test_user_verify_permission_not_permission():
    db = await get_db()  
    result = await verify_permission_role_query(db, 6, '/formula', 'GET')
    assert result is None, "Debería encontrar 0 registro existente"
    await db.close()  


@pytest.mark.asyncio
async def test_user_get_permissions_super():
    db = await get_db()  
    result = await get_permissions_by_role(db, 1)
    assert result[0]["module"] == "*","El super usuario tiene el todos los modulos"
    assert result[0]["resource"] == "*","El super usuario tiene el todos los recursos"
    await db.close()  
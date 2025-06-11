from passlib.context import CryptContext
from datetime import datetime, timedelta
from asyncpg import Connection
import jwt
from repositories.user_repo import login_query, get_permissions_by_role
from schemas.target import UserBase
import hashlib
from auth.jwt_handler import create_access_token
from repositories.enterprise import get_enterprise

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def verify_password(plain_password, hashed_password):
    sha1 = hashlib.sha1(plain_password.encode()).hexdigest()
    return sha1 == hashed_password


async def login_service(db: Connection, user:UserBase):
    result = await login_query(db, user)
    if not result or not verify_password(user.hashed_password, result['password']):
        return False

    access_token = create_access_token(data={"sub": result['username']})
    role_id = result["role_id"]

    permissions = await get_permissions_by_role(db, role_id)

    permissions_result = [dict(record) for record in permissions]

    enterprise = await get_enterprise(db)

    return {
        "access_token": access_token,
        "token_type": "bearer",
        "enterprise":enterprise,
        "user": {
            "name": result['name'],
            "role": result['role'],
            "lastname": result['lastname'],
            "username": result['username'],
            "email": result['email'],
            "permissions": permissions_result
        },
}
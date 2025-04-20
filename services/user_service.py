from passlib.context import CryptContext
from datetime import datetime, timedelta
from asyncpg import Connection
import jwt
from repositories.user_repo import login_query
from schemas.target import UserBase
import hashlib
from auth.jwt_handler import create_access_token

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def verify_password(plain_password, hashed_password):
    sha1 = hashlib.sha1(plain_password.encode()).hexdigest()
    return sha1 == hashed_password


async def login_service(db: Connection, user:UserBase):
    result = await login_query(db, user)
    if not result or not verify_password(user.hashed_password, result['contraseña']):
        return False

    access_token = create_access_token(data={"sub": result['nombre_usuario']})
    return access_token
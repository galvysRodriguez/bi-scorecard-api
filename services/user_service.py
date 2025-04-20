from passlib.context import CryptContext
from datetime import datetime, timedelta
from asyncpg import Connection
import jwt
from repositories.user_repo import login_query
from schemas.target import UserBase
import hashlib

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

SECRET_KEY = "your_secret_key"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

def verify_password(plain_password, hashed_password):
    sha1 = hashlib.sha1(plain_password.encode()).hexdigest()
    return sha1 == hashed_password


def create_access_token(data: dict, expires_delta: timedelta = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)):
    to_encode = data.copy()
    expire = datetime.utcnow() + expires_delta
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


async def login_service(db: Connection, user:UserBase):
    result = await login_query(db, user)
    if not result or not verify_password(user.hashed_password, result['contraseña']):
        return False

    access_token = create_access_token(data={"sub": result['nombre_usuario']})
    return access_token
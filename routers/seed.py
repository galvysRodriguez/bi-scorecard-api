from etl.seed.resources import create_resources_db, delete_resources_db
from etl.seed.profile_resource import create_profile_resource_db, delete_profile_resource_db
from etl.seed.profiles import create_profiles_db, delete_profiles_db
from etl.seed.users import create_users_db, delete_users_db
from fastapi import APIRouter
from datetime import datetime, timedelta
from typing import Optional, List
from etl.db.erp import source_engine
from utils.api_response_etl import api_response_etl

router = APIRouter(prefix="/seed", tags=["seed"])


@router.post("/resource")
async def create_resources_all():
    end = datetime.now()
    await create_resources_db(source_engine)
    start = end - timedelta(days=1)
    return api_response_etl("La creacion de recursos ha sido completada", start, end,  [])

@router.delete("/resource/delete")
async def delete_resources_bi():
    end = datetime.now()
    await delete_resources_db(source_engine)
    start = end - timedelta(days=1)
    return api_response_etl("La eliminacion de recursos ha sido completada", start, end)

@router.post("/users")
async def create_users_all():
    end = datetime.now()
    await create_users_db(source_engine)
    start = end - timedelta(days=1)
    return api_response_etl("La creacion de usuarios ha sido completada", start, end, [])

@router.delete("/users/delete")
async def delete_users_bi():
    end = datetime.now()
    await delete_users_db(source_engine)
    start = end - timedelta(days=1)
    return api_response_etl("La eliminacion de usuarios ha sido completada", start, end)


@router.post("/profile")
async def create_profiles_all():
    end = datetime.now()
    await create_profiles_db(source_engine)
    start = end - timedelta(days=1)
    return api_response_etl("La creacion de perfiles ha sido completada", start, end, [])

@router.delete("/profile/delete")
async def delete_profiles_bi():
    end = datetime.now()
    await delete_profiles_db(source_engine)
    start = end - timedelta(days=1)
    return api_response_etl("La eliminacion de perfiles ha sido completada", start, end)


@router.post("/resource_profile")
async def create_profile_resource_all():
    end = datetime.now()
    await create_profile_resource_db(source_engine)
    start = end - timedelta(days=1)
    return api_response_etl("La creacion de recurso_perfil ha sido completada", start, end, [])

@router.delete("/resource_profile/delete")
async def delete_profile_resource_bi():
    end = datetime.now()
    await delete_profile_resource_db(source_engine)
    start = end - timedelta(days=1)
    return api_response_etl("La eliminacion de recurso_perfil ha sido completada", start, end)


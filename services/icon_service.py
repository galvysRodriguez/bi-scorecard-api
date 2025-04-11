from asyncpg import Connection
from repositories.icon_repo import add_icon, delete_icon, update_icon, get_icon, get_icons, exist_icon
from schemas.target import IconBase
from utils.api_response import api_response


async def global_create_icon(db: Connection, icon: IconBase):
    icon_id = add_icon(db, icon)
    return api_response("Icono creada correctamente", True, {"icon_id": icon_id})


async def global_update_icon(db: Connection, icon: IconBase, icon_id:int):
    value = await update_icon(db, icon_id, icon)  
    return api_response("Etiqueta actualizada correctamente", True, {"icon_id": icon_id})

async def global_delete_icon(db: Connection, icon_id: int):
    result = await delete_icon(db, icon_id)
    return api_response("Etiqueta eliminada correctamente", True, result)

async def global_get_icon(db: Connection, icon_id: int):
    row = await get_icon(db, icon_id)
    if not row:
        return api_response("Icono no encontrada", False)

    return api_response("Icono listada correctamente", True, row)

async def global_get_icons(db: Connection):
    rows = await get_icons(db)
    return api_response("Iconos listadas correctamente", True, rows)

async def global_exist_icon(db: Connection, icon:IconBase):
    rows = await exist_icon(db, icon)
    value = rows["count"] == 1
    return api_response("Iconos listadas correctamente", True, value)
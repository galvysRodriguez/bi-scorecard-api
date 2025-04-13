from asyncpg import Connection
from repositories.perspective_tag_repo import add_perspective_tag, delete_perspective_tag, get_perspective_tag
from repositories.perspective_repo import add_perspective, delete_perspective, update_perspective, get_perspective, get_perspectives, exist_perspective, get_all_perspectives, exist_perspective_update
from utils.api_response import api_response
from schemas.target import PerspectiveBase, PerspectiveCreate

async def add_perspective_tags(db: Connection, perspective_id: int, tags: list[int]):
    """Inserta múltiples Perspectivas usando la función de una en una."""
    results = []

    for tag_id in tags:
        result = await add_perspective_tag(db, perspective_id, tag_id)
        results.append(result)

    return results

async def delete_perspective_tags(db: Connection, perspective_id: int, tags: list[int]):
    """Inserta múltiples Perspectivas usando la función de una en una."""
    results = []

    for tag_id in tags:
        result = await delete_perspective_tag(db, perspective_id, tag_id)
        results.append(result)

    return results

async def sync_tag_perspectives(db: Connection, perspective_id: int, new_perspectives: list[int]):
    """Sincroniza las perspectivas de un tag: agrega nuevas y elimina las que ya no están."""

    # Obtener los IDs actuales desde la base de datos
    current_rows = await get_perspective_tag(db, perspective_id)
    current_ids = set(row["id_perspectivas"] for row in current_rows)
    new_ids = set(new_perspectives)

    to_add = new_ids - current_ids
    to_remove = current_ids - new_ids

    # Agregar las nuevas
    if to_add:
        await add_perspective_tags(db, list(to_add), perspective_id)

    # Eliminar las que ya no están
    if to_remove:
        await delete_perspective_tags(db, list(to_remove), perspective_id)

    return {
        "added": list(to_add),
        "removed": list(to_remove)
    }


async def global_create_perspective(db: Connection, perspective: PerspectiveCreate):
    async with db.transaction():
        # guardar la información del perspective
        perspective_id = await add_perspective(db, perspective)  

        # guardar indicadores del perspective
        await add_perspective_tags(db, perspective_id, perspective.tags)

    return api_response("Perspectiva creada correctamente", True, {"perspective_id": perspective_id})


async def global_update_perspective(db: Connection, perspective: PerspectiveCreate, perspective_id:int):
    async with db.transaction():
        # guardar la información del tag
        await update_perspective(db, perspective_id, perspective)  
        await sync_tag_perspectives(db, perspective_id, perspective.tags)
        
    return api_response("Perspectiva actualizada correctamente", True, {"perspective_id": perspective_id})

async def global_delete_perspective(db: Connection, perspective_id: int):
    result = await delete_perspective(db, perspective_id)
    return api_response("Perspectiva eliminada correctamente", True, result)

async def global_get_perspective(db: Connection, perspective_id: int):
    row = await get_perspective(db, perspective_id)
    if not row:
        return api_response("Perspectiva no encontrada", False)

    perspectives = await get_perspective_tag(db, perspective_id)

    tag_data = dict(row)
    tag_data["tags"] = perspectives

    return api_response("Perspectiva listada correctamente", True, tag_data)

async def global_get_perspectives(db: Connection):
    rows = await get_perspectives(db)
    return api_response("Perspectivas listadas correctamente", True, rows)

async def global_get_perspectives_with_icon(db: Connection):
    rows = await get_all_perspectives(db)
    return api_response("Perspectivas listadas correctamente", True, rows)

async def global_exist_perspective(db: Connection, perspective:PerspectiveBase):
    rows = await exist_perspective(db, perspective)
    value = rows["count"] == 1
    return api_response("Perspectivas listadas correctamente", True, value)


async def global_exist_perspective_update(db: Connection, perspective_id:int, perspective:PerspectiveBase):
    rows = await exist_perspective_update(db, perspective_id, perspective)
    value = rows["count"] == 1
    return api_response("Perspectivas listadas correctamente", True, value)
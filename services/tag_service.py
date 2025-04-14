from asyncpg import Connection
from repositories.perspective_tag_repo import add_perspective_tag, delete_perspective_tag, get_tag_perspective
from repositories.tag_indicator_repo import add_tag_indicator, delete_tag_indicator, get_tag_indicator
from repositories.tag_repo import add_tag, delete_tag, update_tag, get_tag, get_tags, exist_tag, exist_tag_update
from schemas.target import TagCreate, TagBase
from utils.api_response import api_response

async def add_perspectives_tag(db: Connection, perspectives: list[int], tag_id:int):
    """Inserta múltiples etiquetas usando la función de una en una."""
    results = []

    for perspective_id in perspectives:
        result = await add_perspective_tag(db, perspective_id, tag_id)
        results.append(result)

    return results

async def delete_perspectives_tag(db: Connection, perspectives: list[int], tag_id:int):
    """Inserta múltiples etiquetas usando la función de una en una."""
    results = []

    for perspective_id in perspectives:
        result = await delete_perspective_tag(db, perspective_id, tag_id)
        results.append(result)

    return results

async def add_tag_indicators(db: Connection, indicators: list[int], tag_id:int):
    """Inserta múltiples etiquetas usando la función de una en una."""
    results = []

    for indicator_id in indicators:
        result = await add_tag_indicator(db, tag_id, indicator_id)
        results.append(result)

    return results

async def delete_tag_indicators(db: Connection, indicators: list[int], tag_id:int):
    """Inserta múltiples etiquetas usando la función de una en una."""
    results = []

    for indicator_id in indicators:
        result = await delete_tag_indicator(db, tag_id, indicator_id)
        results.append(result)

    return results


async def sync_tag_perspectives(db: Connection, tag_id: int, new_perspectives: list[int]):
    """Sincroniza las perspectivas de un tag: agrega nuevas y elimina las que ya no están."""

    # Obtener los IDs actuales desde la base de datos
    current_rows = await get_tag_perspective(db, tag_id)
    current_ids = set(row["id_perspectivas"] for row in current_rows)
    new_ids = set(new_perspectives)

    to_add = new_ids - current_ids
    to_remove = current_ids - new_ids

    # Agregar las nuevas
    if to_add:
        await add_perspectives_tag(db, list(to_add), tag_id)

    # Eliminar las que ya no están
    if to_remove:
        await delete_perspectives_tag(db, list(to_remove), tag_id)

    return {
        "added": list(to_add),
        "removed": list(to_remove)
    }

async def sync_tag_indicators(db: Connection, tag_id: int, new_indicators: list[int]):
    """Sincroniza las perspectivas de un tag: agrega nuevas y elimina las que ya no están."""

    # Obtener los IDs actuales desde la base de datos
    current_rows = await get_tag_indicator(db, tag_id)
    current_ids = set(row["id"] for row in current_rows)
    new_ids = set(new_indicators)

    to_add = new_ids - current_ids
    to_remove = current_ids - new_ids

    # Agregar las nuevas
    if to_add:
        await add_tag_indicators(db, list(to_add), tag_id)

    # Eliminar las que ya no están
    if to_remove:
        await delete_tag_indicators(db, list(to_remove), tag_id)

    return {
        "added": list(to_add),
        "removed": list(to_remove)
    }



async def global_create_tag(db: Connection, tag: TagCreate):
    async with db.transaction():
        # guardar la información del tag
        tag_id = await add_tag(db, tag)  

        # guardar perspectivas del tag
        await add_perspectives_tag(db, tag.perspectives, tag_id)

        # guardar indicadores del tag
        await add_tag_indicators(db, tag.indicators, tag_id)

    return api_response("Etiqueta creada correctamente", True, {"tag_id": tag_id})


async def global_update_tag(db: Connection, tag: TagCreate, tag_id:int):
    async with db.transaction():
        # guardar la información del tag
        await update_tag(db, tag_id, tag)  
        await sync_tag_perspectives(db, tag.perspectives, tag_id)
        await sync_tag_indicators(db, tag.indicators, tag_id)
        
    return api_response("Etiqueta actualizada correctamente", True, {"tag_id": tag_id})

async def global_delete_tag(db: Connection, tag_id: int):
    result = await delete_tag(db, tag_id)
    return api_response("Etiqueta eliminada correctamente", True, result)

async def global_get_tag(db: Connection, tag_id: int):
    row = await get_tag(db, tag_id)
    if not row:
        return api_response("Etiqueta no encontrada", False)

    indicators = await get_tag_indicator(db, tag_id)
    perspectives = await get_tag_perspective(db, tag_id)

    tag_data = dict(row)
    tag_data["indicators"] = indicators
    tag_data["perspectives"] = perspectives

    return api_response("Etiqueta listada correctamente", True, tag_data)

async def global_get_tags(db: Connection):
    rows = await get_tags(db)
    return api_response("Etiquetas listadas correctamente", True, rows)

async def global_exist_tag(db: Connection, tag:TagBase):
    rows = await exist_tag(db, tag)
    value = rows["count"] == 1
    return api_response("Etiquetas listadas correctamente", True, value)

async def global_exist_tag_update(db: Connection, tag_id:int, tag:TagBase):
    rows = await exist_tag_update(db, tag_id, tag)
    value = rows["count"] == 1
    return api_response("Etiquetas listadas correctamente", True, value)
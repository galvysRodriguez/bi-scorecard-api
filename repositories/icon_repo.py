from asyncpg import Connection
from typing import Optional
from schemas.target import IconBase


async def get_icon(db: Connection, icon_id: int):
        """Consulta una etiqueta por ID."""
        query = f"""
            SELECT e.id_iconos as id, e.icono as icon, 
                    p.id_perspectivas as id_perspective,
                    p.perspectiva as perspective
            FROM objetivos.iconos e
            LEFT JOIN objetivos.perspectivas p ON p.id_iconos = e.id_iconos
            WHERE e.id_iconos = $1 AND e.visible = true
        """
        return await db.fetchrow(query, icon_id)

async def get_icons(db: Connection):
        """Consulta todos las etiquetas"""
        query = f"""
             SELECT e.id_iconos as id, e.icono as icon FROM objetivos.iconos e
             WHERE e.visible = true
        """
        return await db.fetch(query)

    
async def add_icon(db: Connection, icon_data: IconBase):
        """Inserta una nueva etiqueta."""
        query = f"""
            INSERT INTO objetivos.iconos (icono)
            VALUES ($1)
            RETURNING *;
        """

        row = await db.fetchrow(query, icon_data.title)
        return row['id_etiquetas'] if row else None

async def update_icon(db: Connection, icon_id: int,  icon_data:IconBase):
        """Actualiza una etiqueta existente."""
        query = f"""
            UPDATE objetivos.iconos
            SET icono =($2)
            WHERE id_iconos = $1
            RETURNING *;
        """
        row = await db.fetchrow(query, icon_id, icon_data.title)
        return row['id_etiquetas'] if row else None

async def delete_icon(db: Connection, icon_id: int):
        """Elimina un objetivo por ID."""
        query = f"""
            UPDATE objetivos.iconos
            SET visible = false, 
            WHERE id_etiquetas = $1
            RETURNING *;
        """
        return await db.fetchrow(query, icon_id)


async def exist_icon(db: Connection, icon: IconBase):
        """Verifica si existe la etiqueta"""
        query = f"""
            SELECT COUNT(*) FROM objetivos.iconos
            WHERE icono = $1
        """
        return await db.fetchrow(query, icon.title)

async def exist_icon_update(db: Connection, icon_id:int, icon: IconBase):
        """Verifica si existe la formula"""
        query = f"""
            SELECT COUNT(*) as count FROM objetivos.iconos
            WHERE icono = $1 AND id_iconos != $2
        """
        return await db.fetchrow(query, icon.title, icon_id)
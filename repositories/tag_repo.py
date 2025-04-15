from asyncpg import Connection
from typing import Optional
from schemas.target import TagCreate, TagBase


async def get_tag(db: Connection, tag_id: int):
        """Consulta una etiqueta por ID."""
        query = f"""
            SELECT e.id_etiquetas as id, e.etiqueta as title FROM objetivos.etiquetas e
            WHERE e.id_etiquetas = $1 AND e.visible = true
        """
        return await db.fetchrow(query, tag_id)

async def get_tags(db: Connection):
        """Consulta todos las etiquetas"""
        query = f"""
             SELECT e.id_etiquetas as id, e.etiqueta as title FROM objetivos.etiquetas e
             WHERE e.visible = true
        """
        return await db.fetch(query)

    
async def add_tag(db: Connection, tag_data: TagCreate):
        """Inserta una nueva etiqueta."""
        query = f"""
            INSERT INTO objetivos.etiquetas (etiqueta)
            VALUES ($1)
            RETURNING *;
        """

        row = await db.fetchrow(query, tag_data.title)
        return row['id_etiquetas'] if row else None

async def update_tag(db: Connection, tag_id: int,  tag_data:TagCreate):
        """Actualiza una etiqueta existente."""
        query = f"""
            UPDATE objetivos.etiquetas
            SET etiqueta =($2)
            WHERE id_etiquetas = $1
            RETURNING *;
        """
        row = await db.fetchrow(query, tag_id, tag_data.title)
        return row['id_etiquetas'] if row else None

async def delete_tag(db: Connection, tag_id: int):
        """Elimina un objetivo por ID."""
        query = f"""
            UPDATE objetivos.etiquetas
            SET visible = false
            WHERE id_etiquetas = $1
            RETURNING *;
        """
        return await db.fetchrow(query, tag_id)


async def exist_tag(db: Connection, tag: TagBase):
        """Verifica si existe la etiqueta"""
        query = f"""
            SELECT COUNT(*) FROM objetivos.etiquetas
            WHERE etiqueta = $1
        """
        return await db.fetchrow(query, tag.title)

async def exist_tag_update(db: Connection, tag_id:int, tag: TagBase):
        """Verifica si existe la etiqueta"""
        query = f"""
            SELECT COUNT(*) FROM objetivos.etiquetas
            WHERE etiqueta = $1 AND id_etiquetas != $2
        """
        return await db.fetchrow(query, tag.title, tag_id)

from asyncpg import Connection
from typing import Optional
from schemas.target import PerspectiveCreate, PerspectiveBase


async def get_perspective(db: Connection, perspective_id: int):
        """Consulta una perspectiva por ID."""
        query = """
            SELECT e.id_perspectivas as id, e.perspectiva as perspective,
                i.icono as icon
            FROM objetivos.perspectivas e
            LEFT JOIN objetivos.iconos i ON i.id_iconos = e.id_iconos
            WHERE e.id_perspectivas = $1 AND e.visible = true
        """
        return await db.fetchrow(query, perspective_id)

async def get_perspectives(db: Connection):
        """Consulta todos las perspectivas"""
        query = """
             SELECT e.id_perspectivas as id, e.perspectiva as perspective FROM objetivos.perspectivas e
             WHERE e.visible = true
        """
        return await db.fetch(query)

async def get_all_perspectives(db: Connection):
        """Consulta todos las perspectivas"""
        query = """
             SELECT e.id_perspectivas as id, e.perspectiva as perspective,
                 i.icono as icon
               FROM objetivos.perspectivas e
               LEFT JOIN objetivos.iconos i ON i.id_iconos = e.id_iconos
               WHERE e.visible = true
        """
        return await db.fetch(query)
    
async def add_perspective(db: Connection, perspective_data: PerspectiveCreate):
        """Inserta una nueva perspectiva."""
        query = """
            INSERT INTO objetivos.perspectivas (perspectiva, id_iconos)
            VALUES ($1, $2)
            RETURNING *;
        """
        row = await db.fetchrow(query, perspective_data.title, perspective_data.icon_id)
        return row['id_perspectivas'] if row else None

async def update_perspective(db: Connection, perspective_id: int,  perspective_data:PerspectiveCreate):
        """Actualiza una perspectiva existente."""
        query = """
            UPDATE objetivos.perspectivas
            SET titulo =($2),
                id_iconos = ($3)
            WHERE id_perspectivas = $1
            RETURNING *;
        """
        row = await db.fetchrow(query, perspective_id, perspective_data.title, perspective_data.icon_id)
        return row['id_perspectivas'] if row else None

async def delete_perspective(db: Connection, perspective_id: int):
        """Elimina un objetivo por ID."""
        query = """
            UPDATE objetivos.perspectivas
            SET visible = false, 
            WHERE id_perspectivas = $1
            RETURNING *;
        """
        return await db.fetchrow(query, perspective_id)


async def exist_perspective(db: Connection, perspective: PerspectiveBase):
        """Verifica si existe la perspectiva"""
        query = """
            SELECT COUNT(*) FROM objetivos.perspectivas
            WHERE perspectiva = $1
        """
        return await db.fetchrow(query, perspective.title)

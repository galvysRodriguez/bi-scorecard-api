from asyncpg import Connection
from typing import Optional
from schemas.target import TargetCreate, TargetUpdate, TargetBase


class TargetRepository:
    @staticmethod
    async def get_target(db: Connection, target_id: int):
        """Consulta un objetivo por ID."""
        query = f"""
            SELECT o.id_objetivos AS id, o.titulo AS title, o.optimo AS optimal, o.tolerable, 
                   o.deficiente AS deficient, o.fecha_inicio AS start_date, 
                   o.fecha_final AS end_date, o.id_formulas AS formula_id,
                   p.id_perspectivas AS perspective_id,
                   f.titulo AS formula,
                   p.perspectiva AS perspective,
                   e.id_etiquetas AS tag_id,
                   e.etiqueta AS tag
            FROM objetivos.objetivos o
            LEFT JOIN objetivos.formulas f ON f.id_formulas = o.id_formulas
            LEFT JOIN objetivos.perspectiva_etiqueta pe ON pe.id_etiquetas = f.id_etiquetas
            LEFT JOIN objetivos.etiquetas e ON e.id_etiquetas = pe.id_etiquetas
            LEFT JOIN objetivos.perspectivas p ON p.id_perspectivas = pe.id_perspectivas
            WHERE o.id_objetivos = $1
        """
        return await db.fetchrow(query, target_id)

    @staticmethod
    async def get_targets(db: Connection, perspective_id: int):
        """Consulta todos los objetivos."""
        query = f"""
             SELECT o.id_objetivos AS id, o.titulo AS title, o.optimo AS optimal, o.tolerable, 
                   o.deficiente AS deficient, o.fecha_inicio AS start_date, 
                   o.fecha_final AS end_date, o.id_formulas AS indicator_id,
                   f.titulo AS indicator,
                   p.id_perspectivas AS perspective_id,
                   p.perspectiva AS perspective
            FROM objetivos.objetivos o
            LEFT JOIN objetivos.formulas f ON f.id_formulas = o.id_formulas
            LEFT JOIN objetivos.perspectiva_etiqueta pe ON pe.id_etiquetas = f.id_etiquetas
            LEFT JOIN objetivos.perspectivas p ON p.id_perspectivas = pe.id_perspectivas
            WHERE pe.id_perspectivas = $1
            ORDER BY  o.fecha_inicio ASC, o.fecha_final ASC
        """
        return await db.fetch(query, perspective_id)

    @staticmethod
    async def get_all_targets(db: Connection):
        """Consulta todos los objetivos. no esta en produccion"""
        query = f"""
            SELECT o.id_objetivos AS id, o.titulo AS title, o.optimo AS optimal, o.tolerable, 
                   o.deficiente AS deficient, o.fecha_inicio AS start_date, 
                   o.fecha_final AS end_date, o.id_formulas AS indicator_id,
                   p.id_perspectivas AS perspective_id,
                   f.titulo AS indicator,
            FROM objetivos.objetivos o
            LEFT JOIN objetivos.formulas f ON f.id_formulas = o.id_formulas
            LEFT JOIN objetivos.perspectiva_etiqueta pe ON pe.id_etiquetas = f.id_etiquetas
            LEFT JOIN objetivos.perspectivas p ON p.id_perspectivas = pe.id_perspectivas
            ORDER BY  o.fecha_inicio ASC, o.fecha_final ASC
        """
        return await db.fetch(query)

    @staticmethod
    async def add_target(db: Connection, target_data: TargetCreate):
        """Inserta un nuevo objetivo."""
        query = f"""
            INSERT INTO objetivos.objetivos (titulo, optimo, tolerable, deficiente, 
            fecha_inicio, fecha_final, id_formulas)
            VALUES ($1, $2, $3, $4, $5, $6, $7)
            RETURNING *;
        """

        start_date = target_data.start_date.replace(tzinfo=None) if target_data.start_date else None
        end_date = target_data.end_date.replace(tzinfo=None) if target_data.end_date else None

        return await db.fetchrow(
            query,
            target_data.title, target_data.optimal, target_data.tolerable,
            target_data.deficient, start_date, end_date, target_data.formula_id
        )

    @staticmethod
    async def update_target(db: Connection, target_id: int,  target_data:TargetUpdate):
        """Actualiza un objetivo existente."""
        query = f"""
            UPDATE objetivos.objetivos 
            SET titulo =($2), 
                optimo = ($3), 
                tolerable = ($4), 
                deficiente = ($5), 
                fecha_inicio = ($6), 
                fecha_final = ($7), 
                id_formulas = ($8)
            WHERE id_objetivos = $1
            RETURNING *;
        """
        start_date = target_data.start_date.replace(tzinfo=None) if target_data.start_date else None
        end_date = target_data.end_date.replace(tzinfo=None) if target_data.end_date else None

        return await db.fetchrow(
            query,
            target_id,
            target_data.title, target_data.optimal, target_data.tolerable,
            target_data.deficient, start_date, end_date, target_data.indicator_id
        )

    @staticmethod
    async def delete_target(db: Connection, target_id: int):
        """Elimina un objetivo por ID."""
        query = f"""
            DELETE FROM objetivos.objetivos 
            WHERE id_objetivos = $1 
            RETURNING *;
        """
        return await db.fetchrow(query, target_id)
    
    @staticmethod
    async def exist_target(db: Connection, target: TargetBase):
        """Verifica si existe la etiqueta"""
        query = f"""
            SELECT COUNT(*) FROM objetivos.objetivos
            WHERE titulo = $1
        """
        return await db.fetchrow(query, target.title)
    
    @staticmethod
    async def exist_target_update(db: Connection, target_id:int, target: TargetBase):
        """Verifica si existe la etiqueta"""
        query = f"""
            SELECT COUNT(*) FROM objetivos.objetivos
            WHERE titulo = $1 AND id_objetivos = $2
        """
        return await db.fetchrow(query, target.title, target_id)


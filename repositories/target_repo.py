from asyncpg import Connection
from typing import Optional
from schemas.target import TargetCreate


class TargetRepository:
    @staticmethod
    async def get_target(db: Connection, target_id: int):
        """Consulta un objetivo por ID."""
        query = """
            SELECT o.id_objetivos AS id, o.titulo AS title, o.optimo AS optimal, o.tolerable, 
                   o.deficiente AS deficient, o.fecha_inicio AS start_date, 
                   o.fecha_final AS end_date, o.id_formulas AS indicator_id,
                   o.id_perspectivas AS perspective_id,
                   f.titulo AS indicator,
                   p.perspectiva AS perspective
            FROM objetivos.objetivos o
            LEFT JOIN objetivos.formulas f ON f.id_formulas = o.id_formulas
            LEFT JOIN objetivos.perspectivas p ON p.id_perspectivas = o.id_perspectivas 
            WHERE o.id_objetivos = $1
        """
        return await db.fetchrow(query, target_id)

    @staticmethod
    async def get_targets(db: Connection, perspective_id: int):
        """Consulta todos los objetivos."""
        query = """
             SELECT o.id_objetivos AS id, o.titulo AS title, o.optimo AS optimal, o.tolerable, 
                   o.deficiente AS deficient, o.fecha_inicio AS start_date, 
                   o.fecha_final AS end_date, o.id_formulas AS indicator_id,
                   o.id_perspectivas AS perspective_id,
                   f.titulo AS indicator,
                   p.perspectiva AS perspective
            FROM objetivos.objetivos o
            LEFT JOIN objetivos.formulas f ON f.id_formulas = o.id_formulas
            LEFT JOIN objetivos.perspectivas p ON p.id_perspectivas = o.id_perspectivas 
            WHERE o.id_perspectivas = $1
        """
        return await db.fetch(query, perspective_id)

    @staticmethod
    async def get_all_targets(db: Connection):
        """Consulta todos los objetivos."""
        query = """
            SELECT o.id_objetivos AS id, o.titulo AS title, o.optimo AS optimal, o.tolerable, 
                   o.deficiente AS deficient, o.fecha_inicio AS start_date, 
                   o.fecha_final AS end_date, o.id_formulas AS indicator_id,
                   o.id_perspectivas AS perspective_id,
                   f.titulo AS indicator,
                   p.perspectiva AS perspective
            FROM objetivos.objetivos o
            LEFT JOIN objetivos.formulas f ON f.id_formulas = o.id_formulas
            LEFT JOIN objetivos.perspectivas p ON p.id_perspectivas = o.id_perspectivas 
        """
        return await db.fetch(query)

    @staticmethod
    async def add_target(db: Connection, target_data: TargetCreate):
        """Inserta un nuevo objetivo."""
        query = """
            INSERT INTO objetivos.objetivos (titulo, optimo, tolerable, deficiente, 
            fecha_inicio, fecha_final, id_perspectivas, id_formulas)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
            RETURNING *;
        """

        start_date = target_data.start_date.replace(tzinfo=None) if target_data.start_date else None
        end_date = target_data.end_date.replace(tzinfo=None) if target_data.end_date else None

        return await db.fetchrow(
            query,
            target_data.title, target_data.optimal, target_data.tolerable,
            target_data.deficient, start_date, end_date,
            target_data.perspective_id, target_data.formula_id
        )

    @staticmethod
    async def update_target(db: Connection, target_id: int, **kwargs):
        """Actualiza un objetivo existente."""
        query = """
            UPDATE objetivos.objetivos 
            SET titulo = COALESCE($2, titulo), 
                optimo = COALESCE($3, optimo), 
                tolerable = COALESCE($4, tolerable), 
                deficiente = COALESCE($5, deficiente), 
                fecha_inicio = COALESCE($6, id_fecha_inicio), 
                fecha_final = COALESCE($7, id_fecha_final), 
                id_perspectivas = COALESCE($8, id_perspectivas), 
                id_formulas = COALESCE($9, id_formulas)
            WHERE id_objetivos = $1
            RETURNING *;
        """
        return await db.fetchrow(query, target_id, *kwargs.values())

    @staticmethod
    async def delete_target(db: Connection, target_id: int):
        """Elimina un objetivo por ID."""
        query = """
            DELETE FROM objetivos.objetivos 
            WHERE id_objetivos = $1 
            RETURNING *;
        """
        return await db.fetchrow(query, target_id)

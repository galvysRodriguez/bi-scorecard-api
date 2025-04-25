from asyncpg import Connection
from schemas.target import FormulaCreate, FormulaBase

async def get_formula_query(db: Connection):
    query = f"""SELECT 
                    id_formulas as id, 
                    titulo as title
                FROM objetivos.formulas
                WHERE visible = True"""

    return await db.fetch(query)

async def get_formula_with_tag_query(db: Connection):
    query = f"""SELECT 
                    f.id_formulas as id, 
                    f.titulo as title,
                    e.etiqueta as tag,
                    f.id_etiquetas as tag_id
                FROM objetivos.formulas f
                INNER JOIN objetivos.etiquetas e ON e.id_etiquetas = f.id_etiquetas
                WHERE f.visible = True"""

    return await db.fetch(query)

async def get_by_id_formula_query(db: Connection, formula_id: int):
    query = f"""SELECT 
                    f.id_formulas as id, 
                    f.titulo as title,
                    f.formula,
                    f.id_etiquetas as tag_id,
                    e.etiqueta as tag
                FROM objetivos.formulas f
                INNER JOIN objetivos.etiquetas e ON e.id_etiquetas = f.id_etiquetas
                WHERE f.id_formulas = $1 AND f.visible = true"""

    return await db.fetchrow(query, formula_id)

async def get_by_tag_formula_query(db: Connection, tag_id: int):
    query = f"""SELECT 
                    id_formulas as id, 
                    titulo as title
                FROM objetivos.formulas
                WHERE id_etiquetas = $1 AND visible = true"""

    return await db.fetch(query, tag_id)

async def add_formula_query(db: Connection, formula_data: FormulaCreate):
        """Inserta una nueva formula"""
        query = f"""
            INSERT INTO objetivos.formulas (titulo, formula, id_etiquetas)
            VALUES ($1, $2, $3)
            RETURNING *;
        """


        return await db.fetchrow(
            query,
            formula_data.title, formula_data.formula, formula_data.tag_id
        )

async def update_formula_query(db: Connection, formula_id: int,  formula_data:FormulaCreate):
        """Actualiza una etiqueta existente."""
        query = f"""
            UPDATE objetivos.formulas
            SET titulo =($2),
                formula =($3),
                id_etiquetas =($4)
            WHERE id_etiquetas = $1
            RETURNING *;
        """
        return await db.fetchrow(query, formula_id, formula_data.title, formula_data.formula, formula_data.tag_id)

async def delete_formula_query(db: Connection, formula_id: int):
        """Elimina una formula por ID."""
        query = f"""
            UPDATE objetivos.formulas
            SET visible = false
            WHERE id_formulas = $1
            RETURNING *;
        """
        return await db.fetchrow(query, formula_id)


async def exist_formula_query(db: Connection, formula: FormulaBase):
        """Verifica si existe la formula"""
        query = f"""
            SELECT COUNT(*) as count FROM objetivos.formulas
            WHERE titulo = $1
        """
        return await db.fetchrow(query, formula.title)

async def exist_formula_update_query(db: Connection, formula_id:int, formula: FormulaBase):
        """Verifica si existe la formula"""
        query = f"""
            SELECT COUNT(*) as count FROM objetivos.formulas
            WHERE titulo = $1 AND id_formulas != $2
        """
        return await db.fetchrow(query, formula.title, formula_id)
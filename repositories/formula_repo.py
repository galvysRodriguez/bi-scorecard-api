from asyncpg import Connection
from schemas.target import FormulaBase

async def get_formula_query(db: Connection):
    query = """SELECT 
                    id_formulas as id, 
                    titulo as title
                FROM objetivos.formulas"""

    return await db.fetch(query)

async def get_by_id_formula_query(db: Connection, formula_id: int):
    query = """SELECT 
                    id_formulas as id, 
                    titulo as title,
                    formula
                FROM objetivos.formulas
                WHERE id_formulas = $1"""

    return await db.fetchrow(query, formula_id)

async def add_formula_query(db: Connection, formula_data: FormulaBase):
        """Inserta una nueva formula"""
        query = """
            INSERT INTO objetivos.formulas (titulo, formula)
            VALUES ($1, $2)
            RETURNING *;
        """


        return await db.fetchrow(
            query,
            formula_data.title, formula_data.formula
        )
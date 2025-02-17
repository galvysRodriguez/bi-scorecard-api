from asyncpg import Connection

async def get_indicator_query(db: Connection, indicator_id: int, aggregation_id: int):
    """
    Obtiene la consulta SQL base del indicador y la función de agregación correspondiente.
    """
    query = """
        SELECT i.consulta, a.funcion 
        FROM objetivos.objetivos o
        INNER JOIN objetivos.agregaciones a ON a.id_agregaciones = o.id_agregaciones
        INNER JOIN objetivos.indicadores i ON i.id_indicadores = o.id_indicadores
        WHERE a.id_agregaciones = $1 AND i.id_indicadores = $2
    """
    return await db.fetchrow(query, aggregation_id, indicator_id)

async def get_indicator_string_query(db: Connection, indicator: str):
    """
    Obtiene la consulta SQL base del indicador y la función de agregación correspondiente.
    """
    query = """
        SELECT i.consulta
        FROM objetivos.indicadores i
        WHERE i.indicador = $1
    """

    
    return await db.fetchrow(query, indicator)


async def get_indicators_query(db: Connection):
    query = """SELECT 
                    id_indicadores as id, 
                    indicador as indicator 
                FROM objetivos.indicadores"""

    return await db.fetch(query)

async def get_indicators_perspective_query(db: Connection, perspective_id: int):
    query = """SELECT 
                    id_indicadores as id, 
                    indicador as indicator 
                FROM objetivos.indicadores
                WHERE id_perspectivas = $1"""

    return await db.fetch(query, perspective_id)
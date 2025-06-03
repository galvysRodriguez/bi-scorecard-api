from asyncpg import Connection

async def get_indicator_query(db: Connection, indicator_id: int, aggregation_id: int):
    """
    Obtiene la consulta SQL base del indicador y la función de agregación correspondiente.
    """
    query = f"""
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
    query = f"""
        SELECT i.consulta, i.filtro
        FROM objetivos.indicadores i
        WHERE i.indicador = $1
    """

    
    return await db.fetchrow(query, indicator)


async def get_indicators_query(db: Connection):
    query = f"""SELECT 
                    id_indicadores as id, 
                    indicador as indicator,
                    descripcion as description 
                FROM objetivos.indicadores
                WHERE visible = true
                ORDER BY indicador ASC
                """

    return await db.fetch(query)

async def get_indicator_query(db: Connection, indicator_id: int):
    query = f"""SELECT 
                    id_indicadores as id, 
                    indicador as indicator,
                    descripcion as description 
                FROM objetivos.indicadores
                WHERE visible = true AND id_indicadores = $1"""

    return await db.fetchrow(query, indicator_id)


async def get_indicators_tag_query(db: Connection, tag_id: int):
    query = f"""SELECT 
                    i.id_indicadores as id, 
                    i.indicador as indicator,
                FROM objetivos.indicadores i
                INNER JOIN objetivos.etiqueta_indicador ei ON ei.id_indicadores = i.id_indicadores
                WHERE ei.id_etiquetas = $1"""

    return await db.fetch(query, tag_id)
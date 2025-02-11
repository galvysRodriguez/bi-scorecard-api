from asyncpg import Connection

async def get_aggregations_query(db: Connection):
    query = """SELECT 
                    id_agregaciones as id, 
                    agregacion as aggregation
                FROM objetivos.agregaciones"""

    return await db.fetch(query)
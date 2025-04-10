from asyncpg import Connection

async def get_indicator_tag(db: Connection, indicator_id: int):
        """Consulta todos las etiqueta_indicador por perspective_id"""
        query = f"""
            SELECT 
                e.id_etiquetas as id,
                e.etiqueta as tag
            FROM objetivos.etiqueta_indicador e
            INNER JOIN objetivos.etiquetas t ON e.id_etiquetas = t.id_etiquetas
            INNER JOIN objetivos.indicadores i ON i.id_indicadores = e.id_indicadores
            WHERE e.id_indicadores = $1 AND i.visible = true
        """
        return await db.fetchrow(query, indicator_id)

async def get_tag_indicator(db: Connection, tag_id: int):
        """Consulta todos las etiqueta_indicador por tag_id"""
        query = f"""
             SELECT 
                i.id_indicadores as id, 
                i.indicador as indicator
            FROM objetivos.etiqueta_indicador e
            INNER JOIN objetivos.etiquetas t ON e.id_etiquetas = t.id_etiquetas
            INNER JOIN objetivos.indicadores i ON i.id_indicadores = e.id_indicadores
            WHERE e.id_etiquetas = $1 AND t.visible = true
        """
        return await db.fetch(query, tag_id)


async def add_tag_indicator(db: Connection, tag_id: int, indicator_id: int):
        """Inserta una nueva etiqueta_indicador."""
        query = f"""
            INSERT INTO objetivos.etiqueta_indicador (id_etiquetas, id_indicadores)
            VALUES ($1, $2)
            RETURNING *;
        """

        return await db.fetchrow(query, tag_id, indicator_id)


async def delete_tag_indicator(db: Connection, tag_id: int, indicator_id: int):
        """Elimina una etiqueta_indicador por ID."""
        query = f"""
            DELETE FROM objetivos.etiqueta_indicador
            WHERE id_etiquetas = $1 AND id_indicadores = $2
            RETURNING *;
        """
        return await db.fetchrow(query, tag_id, indicator_id)

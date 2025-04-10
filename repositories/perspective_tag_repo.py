from asyncpg import Connection

async def get_perspective_tag(db: Connection, perspective_id: int):
        """Consulta todos las perspectiva_etiqueta por perspective_id"""
        query = f"""
            SELECT 
                e.id_etiquetas as id, 
                e.eriqueta as tag
            FROM objetivos.perspectiva_etiqueta e
            INNER JOIN objetivos.etiquetas t ON e.id_etiquetas = t.id_etiquetas
            INNER JOIN objetivos.perspectivas p ON p.id_perspectivas = e.id_perspectivas
            WHERE e.id_perspectivas = $1 AND p.visible = true
        """
        return await db.fetchrow(query, perspective_id)

async def get_tag_perspective(db: Connection, tag_id: int):
        """Consulta todos las perspectiva_etiqueta por tag_id"""
        query = f"""
             SELECT 
                e.id_perspectivas as id, 
                p.perspectiva as perspective
            FROM objetivos.perspectiva_etiqueta e
            INNER JOIN objetivos.etiquetas t ON e.id_etiquetas = t.id_etiquetas
            INNER JOIN objetivos.perspectivas p ON p.id_perspectivas = e.id_perspectivas
            WHERE e.id_etiquetas = $1 AND t.visible = true
        """
        return await db.fetch(query, tag_id)


async def add_perspective_tag(db: Connection, perspective_id: int, tag_id: int):
        """Inserta una nueva perspectiva_etiqueta."""
        query = f"""
            INSERT INTO objetivos.perspectiva_etiqueta (id_perspectivas, id_etiquetas)
            VALUES ($1, $2)
            RETURNING *;
        """

        return await db.fetchrow(query, perspective_id, tag_id)


async def delete_perspective_tag(db: Connection, perspective_id: int, tag_id: int):
        """Elimina una perspectiva_etiqueta por ID."""
        query = f"""
            DELETE FROM objetivos.perspectiva_etiqueta
            WHERE id_perspectivas = $1 AND id_etiquetas = $2
            RETURNING *;
        """
        return await db.fetchrow(query, perspective_id, tag_id)

from asyncpg import Connection
from typing import Optional
from schemas.target import IconBase


async def get_enterprise(db: Connection):
    """Consulta una etiqueta por ID."""
    query = f"""
        SELECT 
            id_empresas as id,
            rif,
            telefono as phone,
            nombre_comercial as business_name,
            razon_social as company_name,
            direccion as address
        FROM public.empresas
        """
    return await db.fetchrow(query)
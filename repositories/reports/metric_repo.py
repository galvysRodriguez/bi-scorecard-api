from asyncpg import Connection

async def get_value_inventory(db: Connection, date_from:str, date_to:str):
        """Consulta el valor monetario del inventario por fecha"""
        query = f"""
             WITH ultimas_compras AS (
                SELECT 
                    vc.id_productos,
                    vc.costo,
                    vc.fecha,
                    ROW_NUMBER() OVER (PARTITION BY vc.id_productos ORDER BY vc.fecha DESC) AS fila
                FROM compras.vw_compras vc
                ),

                costo_promedio_reciente AS (
                SELECT 
                    id_productos,
                    AVG(costo) AS costo_promedio
                FROM ultimas_compras
                WHERE fila <= 3
                GROUP BY id_productos
                ),

                productos_stock as (
                    SELECT 
                        va2.id_productos,
                        va2.fecha,
                            CASE
                                WHEN va2.entrada = 1 THEN va2.cantidad
                                ELSE -va2.cantidad
                            END AS cantidad
                    FROM almacenes.movimientos va2
                ),

                fechas AS (
                    SELECT generate_series($1::date, $2::date, interval '1 day')::date AS fecha
                )

                SELECT 
                    f.fecha as date,
                    coalesce(round(sum(ps.cantidad * cp.costo_promedio),2),0) as value
                FROM fechas f
                left join almacenes.movimientos va on va.fecha = f.fecha
                left JOIN costo_promedio_reciente cp ON cp.id_productos = va.id_productos
                left join productos_stock ps on ps.id_productos = va.id_productos 
                group by f.fecha
                ORDER BY f.fecha
        """
        return await db.fetch(query, date_from, date_to)

async def get_value_sale(db: Connection, date_from:str, date_to:str):
        """Consulta el valor monetario de las ventas por fecha"""
        query = f"""
            WITH fechas AS (
                SELECT generate_series($1::date, $2::date, interval '1 day')::date AS fecha
            )
            select 
                coalesce(round(sum(vv.total),2),0) as value,
                f.fecha as date
            from fechas f
            left join ventas.vw_ventas vv on vv.fecha = f.fecha
            group by f.fecha
            order by f.fecha 
        """
        return await db.fetch(query, date_from, date_to)

async def get_value_purchase(db: Connection, date_from:str, date_to:str):
        """Consulta el valor monetario de las compras por fecha"""
        query = f"""
            WITH fechas AS (
                SELECT generate_series($1::date, $2::date, interval '1 day')::date AS fecha
            )
             select 
                coalesce(round(sum(vv.total),2),0) as value,
                f.fecha as date
            from fechas f
            left join compras.vw_compras vv on vv.fecha = f.fecha
            group by f.fecha
            order by f.fecha 
        """
        return await db.fetch(query, date_from, date_to)
from asyncpg import Connection

async def get_value_inventory(db: Connection, date_from:str, date_to:str, warehouse:str):
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
                        va2.id_depositos,
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
                    f.fecha,
                    d.deposito,
                    coalesce(round(sum(ps.cantidad * cp.costo_promedio),2),0) as monto
                FROM fechas f
                left join almacenes.movimientos va on va.fecha = f.fecha
                JOIN costo_promedio_reciente cp ON cp.id_productos = va.id_productos
                join productos_stock ps on ps.id_productos = va.id_productos 
                join almacenes.depositos d on d.id_depositos = va.id_depositos and d.deposito like $3
                group by f.fecha, d.deposito
                ORDER BY f.fecha
        """
        return await db.fetch(query, date_from, date_to, warehouse)

async def get_value_sale(db: Connection, date_from:str, date_to:str, warehouse:str):
        """Consulta el valor monetario de las ventas por fecha"""
        query = f"""
            WITH fechas AS (
                SELECT generate_series($1::date, $2::date, interval '1 day')::date AS fecha
            )
            select 
                coalesce(round(vv.total,2),0) as monto,
                f.fecha,
                vv.deposito
            from fechas f
            left join ventas.vw_ventas vv on vv.fecha = f.fecha and vv.deposito like $3
            group by f.fecha, vv.total, vv.deposito 
            order by f.fecha 
        """
        return await db.fetch(query, date_from, date_to, warehouse)

async def get_value_purchase(db: Connection, date_from:str, date_to:str, warehouse:str):
        """Consulta el valor monetario de las compras por fecha"""
        query = f"""
            WITH fechas AS (
                SELECT generate_series($1::date, $2::date, interval '1 day')::date AS fecha
            )
             select 
                coalesce(round(vv.total,2),0) as monto,
                f.fecha,
                vv.deposito
            from fechas f
            left join compras.vw_compras vv on vv.fecha = f.fecha and vv.deposito like $3
            group by f.fecha, vv.total, vv.deposito 
            order by f.fecha 
        """
        return await db.fetch(query, date_from, date_to, warehouse)
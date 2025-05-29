from sqlalchemy import text

create_view_query = """
CREATE MATERIALIZED VIEW ventas.vw_cotizaciones AS
select
    dv.id_det_cotizacion as id,
	dv.cantidad,
    dv.precio,
    round(dv.precio * v.tasa, 2) as precio_bs,
    dv.precio * dv.cantidad as subtotal,
    round(dv.precio * v.tasa * dv.cantidad, 2) as subtotal_bs,
	dv.descuento as descuento_porcentaje,
	round(dv.precio * dv.descuento* v.tasa * dv.cantidad/100, 2) as descuento,
	round(dv.precio * dv.descuento * v.tasa * dv.cantidad/100, 2) as descuento_bs,
	dv.precio * dv.cantidad - round(dv.precio * dv.descuento* v.tasa * dv.cantidad/100, 2) as total,
	round(dv.precio * v.tasa * dv.cantidad, 2) - round(dv.precio * dv.descuento * v.tasa * dv.cantidad/100, 2) as total_bs,

	v.num_control,
	v.tasa,
	v2.nombre as vendedor,
	v2.porcentaje as porcentaje_vendedor,
	c.ciudad,
	e.estado,
	p.nombre as cliente,
    p.direccion as cliente_direccion,
    p.nombre_comercial as cliente_comercial,
	d.deposito,
    f.*,
    tc.tipo as tipo_cliente,
    vp.*,
	CASE 
        WHEN (
                select COUNT(*) from ventas.ventas v
                where v.id_cotizaciones = dv.id_cotizaciones
            ) >= 1 THEN 
            true
        ELSE false
    END AS vendido
from ventas.det_cotizacion dv 
inner join ventas.cotizaciones v on v.id_cotizaciones = dv.id_cotizaciones 
left join ventas.vendedores v2 on v2.id_vendedores = dv.id_vendedores 
left join public.ciudades c on c.id_ciudades = v.id_ciudades
left join public.estados e on e.id_estados = v.id_estados 
left join public.personas p on p.id_personas = v.id_personas 
left join productos.vw_productos vp on vp.id_productos = dv.id_productos 
left join public.fechas f on f.fecha = v.fecha 
left join ventas.tipo_clientes tc on tc.id_tipo_clientes = v.id_tipo_clientes
left join almacenes.depositos d on d.id_depositos = dv.id_depositos 
WITH DATA;
"""

create_function_query = """
CREATE OR REPLACE FUNCTION ventas.fn_refrescar_cotizaciones()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' OR TG_OP = 'DELETE' THEN
        IF NOT pg_trigger_depth() > 1 THEN
            REFRESH MATERIALIZED VIEW CONCURRENTLY ventas.vw_cotizaciones;
        END IF;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
"""

create_trigger_query = """
CREATE TRIGGER tg_actualizar_cotizaciones
AFTER INSERT OR UPDATE OR DELETE ON ventas.cotizaciones 
FOR EACH STATEMENT
EXECUTE FUNCTION ventas.fn_refrescar_cotizaciones();
"""

create_index_query = """
CREATE UNIQUE INDEX idx_vw_cotizaciones_id ON ventas.vw_cotizaciones (id);
"""
delete_trigger_query = "DROP TRIGGER IF EXISTS tg_actualizar_cotizaciones ON ventas.cotizaciones;"
delete_function_query = "DROP FUNCTION IF EXISTS ventas.fn_refrescar_cotizaciones();"
delete_index_query = "DROP INDEX IF EXISTS ventas.idx_vw_cotizaciones_id;"
delete_view_query = "DROP MATERIALIZED VIEW IF EXISTS ventas.vw_cotizaciones;"

async def create_view_quote_db(engine):
    try:
        with engine.begin() as conn:
            conn.execute(text(create_view_query))
            conn.execute(text(create_function_query))
            conn.execute(text(create_trigger_query))
            conn.execute(text(create_index_query))
            print("✅ Vista, función, trigger e índice creados correctamente.")
    except Exception as e:
        print(f"❌ Error creando vista o componentes: {e}")

async def delete_view_quote_db(engine):
    try:
        with engine.begin() as conn:
            conn.execute(text(delete_trigger_query))
            conn.execute(text(delete_function_query))
            conn.execute(text(delete_index_query))
            conn.execute(text(delete_view_query))
            print("✅ Vista, función, trigger e índice eliminados correctamente.")
    except Exception as e:
        print(f"❌ Error eliminando vista o componentes: {e}")

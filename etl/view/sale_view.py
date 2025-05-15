from sqlalchemy import text

create_view_query = """
CREATE MATERIALIZED VIEW ventas.vw_ventas AS
select
    dv.id_det_venta as id,
	dv.cantidad,
	dv.descuento,
	dv.devuelto,
	v.num_control,
	v.num_factura,
	v.tasa,
	v2.nombre as vendedor,
	v2.porcentaje as porcentaje_vendedor,
	c.ciudad,
	e.estado,
	p.*,
	d.deposito,
	c2.caja,
	p2.presentacion,
    tf.tipo as tipo_factura,
	f.*,
    vp.*
from ventas.det_venta dv 
inner join ventas.ventas v on v.id_ventas = dv.id_ventas 
left join ventas.vendedores v2 on v2.id_vendedores = dv.id_vendedores 
left join public.ciudades c on c.id_ciudades = v.id_ciudades
left join public.estados e on e.id_estados = v.id_estados 
left join public.personas p on p.id_personas = v.id_personas 
left join productos.presentaciones p2 on p2.id_presentaciones = dv.id_presentaciones 
left join productos.vw_productos vp on vp.id_productos = dv.id_productos 
left join public.fechas f on f.fecha = v.fecha 
left join finanzas.cajas c2 on c2.id_cajas = v.id_cajas 
left join public.tipo_facturas tf on tf.id_tipo_facturas = v.id_tipo_facturas 
left join almacenes.depositos d on d.id_depositos = dv.id_depositos 
WITH DATA;
"""

create_function_query = """
CREATE OR REPLACE FUNCTION ventas.fn_refrescar_ventas()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' OR TG_OP = 'DELETE' THEN
        IF NOT pg_trigger_depth() > 1 THEN
            REFRESH MATERIALIZED VIEW CONCURRENTLY ventas.vw_ventas;
        END IF;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
"""

create_trigger_query = """
CREATE TRIGGER tg_actualizar_ventas
AFTER INSERT OR UPDATE OR DELETE ON ventas.ventas 
FOR EACH STATEMENT
EXECUTE FUNCTION ventas.fn_refrescar_ventas();
"""

create_index_query = """
CREATE UNIQUE INDEX idx_vw_ventas_id ON ventas.vw_ventas (id);
"""
delete_trigger_query = "DROP TRIGGER IF EXISTS tg_actualizar_ventas ON ventas.ventas;"
delete_function_query = "DROP FUNCTION IF EXISTS ventas.fn_refrescar_ventas();"
delete_index_query = "DROP INDEX IF EXISTS ventas.idx_vw_ventas_id;"
delete_view_query = "DROP MATERIALIZED VIEW IF EXISTS ventas.vw_ventas;"

async def create_view_sale_db(engine):
    try:
        with engine.begin() as conn:
            conn.execute(text(create_view_query))
            conn.execute(text(create_function_query))
            conn.execute(text(create_trigger_query))
            conn.execute(text(create_index_query))
            print("✅ Vista, función, trigger e índice creados correctamente.")
    except Exception as e:
        print(f"❌ Error creando vista o componentes: {e}")

async def delete_view_sale_db(engine):
    try:
        with engine.begin() as conn:
            conn.execute(text(delete_trigger_query))
            conn.execute(text(delete_function_query))
            conn.execute(text(delete_index_query))
            conn.execute(text(delete_view_query))
            print("✅ Vista, función, trigger e índice eliminados correctamente.")
    except Exception as e:
        print(f"❌ Error eliminando vista o componentes: {e}")

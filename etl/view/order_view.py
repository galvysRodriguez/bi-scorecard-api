from sqlalchemy import text

create_view_query = """
CREATE MATERIALIZED VIEW compras.vw_ordenes AS
select 
	dc.id_det_orden_compra as id,
	dc.cantidad,
	dc.costo,
	d.deposito,
	dc.descuento,
	p.proveedor,
	tp.tipo as tipo_proveedor,
	c.tasa,
    f.*,
    vp.*,
    CASE 
        WHEN (
                select COUNT(*) from compras.compras c
                where c.id_ordenes_compras = dc.id_ordenes_compras
            ) >= 1 THEN 
                    true
        ELSE false
    END AS comprado
from compras.det_orden_compra dc 
inner join compras.ordenes_compras c on c.id_ordenes_compras = dc.id_ordenes_compras
left join compras.proveedores p on p.id_proveedores = c.id_proveedores 
left join compras.tipo_proveedores tp on tp.id_tipo_proveedores = p.id_tipo_proveedores 
left join almacenes.depositos d on d.id_depositos = dc.id_depositos 
left join productos.vw_productos vp on vp.id_productos = dc.id_productos 
left join public.fechas f on f.fecha = c.fecha 
WITH DATA;
"""

create_function_query = """
CREATE OR REPLACE FUNCTION compras.fn_refrescar_ordenes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' OR TG_OP = 'DELETE' THEN
        IF NOT pg_trigger_depth() > 1 THEN
            REFRESH MATERIALIZED VIEW CONCURRENTLY compras.vw_ordenes;
        END IF;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
"""

create_trigger_query = """
CREATE TRIGGER tg_actualizar_ordenes
AFTER INSERT OR UPDATE OR DELETE ON compras.compras 
FOR EACH STATEMENT
EXECUTE FUNCTION compras.fn_refrescar_ordenes();
"""

create_index_query = """
CREATE UNIQUE INDEX idx_vw_ordenes_id ON compras.vw_ordenes (id);
"""
delete_trigger_query = "DROP TRIGGER IF EXISTS tg_actualizar_ordenes ON compras.compras;"
delete_function_query = "DROP FUNCTION IF EXISTS compras.fn_refrescar_ordenes();"
delete_index_query = "DROP INDEX IF EXISTS compras.idx_vw_ordenes_id;"
delete_view_query = "DROP MATERIALIZED VIEW IF EXISTS compras.vw_ordenes;"

async def create_view_order_db(engine):
    try:
        with engine.begin() as conn:
            conn.execute(text(create_view_query))
            conn.execute(text(create_function_query))
            conn.execute(text(create_trigger_query))
            conn.execute(text(create_index_query))
            print("✅ Vista, función, trigger e índice creados correctamente.")
    except Exception as e:
        print(f"❌ Error creando vista o componentes: {e}")

async def delete_view_order_db(engine):
    try:
        with engine.begin() as conn:
            conn.execute(text(delete_trigger_query))
            conn.execute(text(delete_function_query))
            conn.execute(text(delete_index_query))
            conn.execute(text(delete_view_query))
            print("✅ Vista, función, trigger e índice eliminados correctamente.")
    except Exception as e:
        print(f"❌ Error eliminando vista o componentes: {e}")

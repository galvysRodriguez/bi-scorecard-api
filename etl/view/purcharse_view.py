from sqlalchemy import text

create_view_query = """
CREATE MATERIALIZED VIEW compras.vw_compras AS
select 
	dc.id_det_compra as id,
	dc.cantidad,
	dc.costo,
	d.deposito,
	dc.descuento,
	p.proveedor,
	tp.tipo as tipo_proveedor,
	c.num_control,
	c.num_factura,
    tf.tipo as tipo_factura,
	c.tasa,
    f.*,
    vp.*,
    pr.presentacion, 
    pr.modificador
from compras.det_compra dc 
inner join compras.compras c on c.id_compras = dc.id_compras 
left join compras.proveedores p on p.id_proveedores = c.id_proveedores 
left join compras.tipo_proveedores tp on tp.id_tipo_proveedores = p.id_tipo_proveedores 
left join public.tipo_facturas tf on tf.id_tipo_facturas = c.id_tipo_facturas 
left join almacenes.depositos d on d.id_depositos = dc.id_depositos 
left join productos.vw_productos vp on vp.id_productos = dc.id_productos 
left join public.fechas f on f.fecha = c.fecha 
left join productos.presentaciones pr on pr.id_presentaciones = dc.id_presentaciones
WITH DATA;
"""

create_function_query = """
CREATE OR REPLACE FUNCTION compras.fn_refrescar_compras()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' OR TG_OP = 'DELETE' THEN
        IF NOT pg_trigger_depth() > 1 THEN
            REFRESH MATERIALIZED VIEW CONCURRENTLY compras.vw_compras;
        END IF;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
"""

create_trigger_query = """
CREATE TRIGGER tg_actualizar_compras
AFTER INSERT OR UPDATE OR DELETE ON compras.compras 
FOR EACH STATEMENT
EXECUTE FUNCTION compras.fn_refrescar_compras();
"""

create_index_query = """
CREATE UNIQUE INDEX idx_vw_compras_id ON compras.vw_compras (id);
"""
delete_trigger_query = "DROP TRIGGER IF EXISTS tg_actualizar_compras ON compras.compras;"
delete_function_query = "DROP FUNCTION IF EXISTS compras.fn_refrescar_compras();"
delete_index_query = "DROP INDEX IF EXISTS compras.idx_vw_compras_id;"
delete_view_query = "DROP MATERIALIZED VIEW IF EXISTS compras.vw_compras;"

async def create_view_purchase_db(engine):
    try:
        with engine.begin() as conn:
            conn.execute(text(create_view_query))
            conn.execute(text(create_function_query))
            conn.execute(text(create_trigger_query))
            conn.execute(text(create_index_query))
            print("✅ Vista, función, trigger e índice creados correctamente.")
    except Exception as e:
        print(f"❌ Error creando vista o componentes: {e}")

async def delete_view_purchase_db(engine):
    try:
        with engine.begin() as conn:
            conn.execute(text(delete_trigger_query))
            conn.execute(text(delete_function_query))
            conn.execute(text(delete_index_query))
            conn.execute(text(delete_view_query))
            print("✅ Vista, función, trigger e índice eliminados correctamente.")
    except Exception as e:
        print(f"❌ Error eliminando vista o componentes: {e}")

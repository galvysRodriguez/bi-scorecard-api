from sqlalchemy import text

create_view_query = """
CREATE MATERIALIZED VIEW productos.vw_productos AS
select 
	p.id_productos as id_productos,
	p.titulo as producto,
	p.codigo,
	c.categoria,
	s.subcategoria,
	tp.tipo as tipo_producto,
	u.unidad,
	m.marca,
	(
		select string_agg(p2.titulo || '-' || dp.cantidad, ', ' ORDER BY p2.titulo)
		from productos.detalle_productos dp 
		inner join productos.productos p2 on dp.id_ingredientes = p2.id_productos
		where dp.id_productos = p.id_productos
	) as detalles,
	(
		select string_agg(p3.presentacion || '-' || p3.modificador, ', ' ORDER BY p3.presentacion)
		from productos.presentaciones p3
		where p3.id_productos = p.id_productos
	) as presentaciones

from productos.productos p 
left join productos.categorias c on c.id_categorias = p.id_categorias 
left join productos.subcategorias s on s.id_subcategorias = p.id_subcategorias 
left join productos.tipo_productos tp on tp.id_tipo_productos = p.id_tipo_productos 
left join productos.unidades u on u.id_unidades = p.id_unidades 
left join productos.marcas m on m.id_marcas = p.id_marcas 
WITH DATA;
"""

create_function_query = """
CREATE OR REPLACE FUNCTION productos.fn_refrescar_productos()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' OR TG_OP = 'DELETE' THEN
        IF NOT pg_trigger_depth() > 1 THEN
            REFRESH MATERIALIZED VIEW CONCURRENTLY productos.vw_productos;
        END IF;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
"""

create_trigger_query = """
CREATE TRIGGER tg_actualizar_productos
AFTER INSERT OR UPDATE OR DELETE ON productos.productos
FOR EACH STATEMENT
EXECUTE FUNCTION productos.fn_refrescar_productos();
"""

create_index_query = """
CREATE UNIQUE INDEX idx_vw_productos_id ON productos.vw_productos (id_productos);
"""
delete_trigger_query = "DROP TRIGGER IF EXISTS tg_actualizar_productos ON productos.productos;"
delete_function_query = "DROP FUNCTION IF EXISTS productos.fn_refrescar_productos();"
delete_index_query = "DROP INDEX IF EXISTS productos.idx_vw_productos_id;"
delete_view_query = "DROP MATERIALIZED VIEW IF EXISTS productos.vw_productos;"

async def create_view_product_db(engine):
    try:
        with engine.begin() as conn:
            conn.execute(text(create_view_query))
            conn.execute(text(create_function_query))
            conn.execute(text(create_trigger_query))
            conn.execute(text(create_index_query))
            print("✅ Vista, función, trigger e índice creados correctamente.")
    except Exception as e:
        print(f"❌ Error creando vista o componentes: {e}")

async def delete_view_product_db(engine):
    try:
        with engine.begin() as conn:
            conn.execute(text(delete_trigger_query))
            conn.execute(text(delete_function_query))
            conn.execute(text(delete_index_query))
            conn.execute(text(delete_view_query))
            print("✅ Vista, función, trigger e índice eliminados correctamente.")
    except Exception as e:
        print(f"❌ Error eliminando vista o componentes: {e}")
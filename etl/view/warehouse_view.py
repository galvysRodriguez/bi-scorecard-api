from sqlalchemy import text

create_view_query = """
CREATE MATERIALIZED VIEW almacenes.vw_almacenes AS
SELECT 
    m.id_movimientos AS id,
    d.deposito,
    tm.movimiento AS tipo_movimiento, 
    vp.*,
    m.cantidad,
    f.*
FROM almacenes.movimientos m 
INNER JOIN almacenes.depositos d ON d.id_depositos = m.id_depositos 
INNER JOIN almacenes.tipo_movimientos tm ON tm.id_tipo_movimientos = m.id_tipo_movimientos 
INNER JOIN productos.vw_productos vp ON vp.id_productos = m.id_productos 
INNER JOIN public.fechas f ON f.fecha = m.fecha 
WITH DATA;
"""

create_function_query = """
CREATE OR REPLACE FUNCTION almacenes.fn_refrescar_almacenes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' OR TG_OP = 'DELETE' THEN
        IF NOT pg_trigger_depth() > 1 THEN
            REFRESH MATERIALIZED VIEW CONCURRENTLY almacenes.vw_almacenes;
        END IF;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
"""

create_trigger_query = """
CREATE TRIGGER tg_actualizar_almacenes
AFTER INSERT OR UPDATE OR DELETE ON almacenes.movimientos 
FOR EACH STATEMENT
EXECUTE FUNCTION almacenes.fn_refrescar_almacenes();
"""

create_index_query = """
CREATE UNIQUE INDEX idx_vw_almacenes_id ON almacenes.vw_almacenes (id);
"""
delete_trigger_query = "DROP TRIGGER IF EXISTS tg_actualizar_almacenes ON almacenes.movimientos;"
delete_function_query = "DROP FUNCTION IF EXISTS almacenes.fn_refrescar_almacenes();"
delete_index_query = "DROP INDEX IF EXISTS almacenes.idx_vw_almacenes_id;"
delete_view_query = "DROP MATERIALIZED VIEW IF EXISTS almacenes.vw_almacenes;"

async def create_view_warehouse_db(engine):
    try:
        with engine.begin() as conn:
            conn.execute(text(create_view_query))
            conn.execute(text(create_function_query))
            conn.execute(text(create_trigger_query))
            conn.execute(text(create_index_query))
            print("✅ Vista, función, trigger e índice creados correctamente.")
    except Exception as e:
        print(f"❌ Error creando vista o componentes: {e}")

async def delete_view_warehouse_db(engine):
    try:
        with engine.begin() as conn:
            conn.execute(text(delete_trigger_query))
            conn.execute(text(delete_function_query))
            conn.execute(text(delete_index_query))
            conn.execute(text(delete_view_query))
            print("✅ Vista, función, trigger e índice eliminados correctamente.")
    except Exception as e:
        print(f"❌ Error eliminando vista o componentes: {e}")
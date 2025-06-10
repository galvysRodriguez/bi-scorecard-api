from sqlalchemy import text

query = """
    delete from almacenes.movimientos; 

    delete from compras.det_compra;
    delete from compras.compras;
    delete from compras.det_orden_compra;
    delete from compras.ordenes_compras;
    delete from compras.proveedores;
    delete from compras.tipo_proveedores;

    delete from finanzas.egreso_caja;
    delete from finanzas.egreso_banco;
    delete from finanzas.egresos;
    delete from finanzas.ingreso_caja;
    delete from finanzas.ingreso_banco;
    delete from finanzas.ingresos;
    delete from finanzas.bancos;
    delete from finanzas.tipo_bancos;

    delete from ventas.det_venta;
    delete from ventas.ventas;
    delete from ventas.det_cotizacion;
    delete from ventas.cotizaciones;
    delete from ventas.cajas;
    delete from ventas.vendedores;
    delete from ventas.tipo_clientes;

    delete from public.personas;
    delete from public.ciudades;
    delete from public.estados;
    
    delete from public.role_permiso;
    delete from public.permisos;
    delete from public.usuarios;
    delete from public.roles;
    
    delete from public.tipo_facturas;
    

    delete from productos.detalle_productos; 
    delete from productos.presentaciones;
    delete from productos.productos;
    delete from productos.unidades;
    delete from productos.subcategorias;
    delete from productos.categorias;
    delete from productos.marcas;

    delete from almacenes.depositos;
"""

async def clear_destination_db(destination_engine):
    try:
        with destination_engine.begin() as conn:  
            conn.execute(text(query))
            print("✅ Datos eliminados correctamente en la base de datos de destino.")
    except Exception as e:
        print(f"❌ Error eliminando datos: {e}")

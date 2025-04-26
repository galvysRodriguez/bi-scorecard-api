query_base_warehouse = """
    SELECT m.id_movimientos FROM almacenes.movimientos m
    INNER JOIN almacenes.depositos d ON d.id_depositos = m.id_depositos 
    INNER JOIN almacenes.tipo_movimientos tm ON tm.id_tipo_movimientos = m.id_tipo_movimientos 
    INNER JOIN productos.productos p ON p.id_productos = m.id_productos 
"""

query_base_purchase = """
    select vc.id_compra from compras.vw_compras vc 
    inner join productos.productos p on p.id_productos = vc.id_productos 
    inner join almacenes.depositos d on d.id_depositos = vc.id_depositos 
    left join productos.presentaciones p2 on p2.id_presentaciones = vc.id_presentaciones 
"""

query_base_sale = """
    select vv.id_det_venta from ventas.vw_ventas vv 
    inner join productos.productos p on vv.id_productos = p.id_productos 
    left join productos.presentaciones p2 on vv.id_presentaciones = p2.id_presentaciones 
    left join ventas.tipo_clientes tc on vv.id_tipo_clientes = tc.id_tipo_clientes 
    left join almacenes.depositos d on vv.id_depositos = d.id_depositos 
    left join public.ciudades c on vv.id_ciudades = c.id_ciudades 
    left join public.estados e on vv.id_estados = e.id_estados 
    left join finanzas.cajas c2 on vv.id_cajas = c2.id_cajas 
    left join public.personas p3 on vv.id_personas = p3.id_personas 
    left join ventas.vendedores v on vv.id_vendedores = v.id_vendedores 
"""
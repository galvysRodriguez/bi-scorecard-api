query_base_warehouse = """
    SELECT m.id_movimientos as id FROM almacenes.movimientos m
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

query_base_sale_view = """
    SELECT
        id,
        cantidad AS quantity,
        descuento AS discount,
        devuelto AS returned,
        
        num_control AS control_number,
        num_factura AS invoice_number,
        tasa AS tax_rate,

        cliente_direccion as customer_address,
        cliente_comercial as customer_commercial,
        cliente as customer_name,
        tipo_cliente as customer_type,
        
        vendedor AS seller_name,
        porcentaje_vendedor AS seller_percentage,
        
        ciudad AS city,
        estado AS state,
        
        id_productos AS product_id,
        producto AS product_name,
        codigo AS product_code,
        categoria AS category,
        subcategoria AS subcategory,
        tipo_producto AS product_type,
        unidad AS unit,
        marca AS brand,
        
        detalles AS product_details,
        presentaciones AS product_presentations,
        presentacion as presentation,
        modificador as modificator,
        
        deposito AS warehouse,
        caja AS cash_register,
        
        tipo_factura AS invoice_type,

        fecha AS date,
        dia AS day,
        dia_semana AS weekday_number,
        nombre_dia AS weekday_name,
        semana_anio AS week_of_year,
        semana_mes AS week_of_month,
        quincena AS fortnight,
        mes AS month,
        nombre_mes AS month_name,
        trimestre AS quarter,
        semestre AS semester,
        anio AS year,
        es_fin_de_semana AS is_weekend
    FROM
        ventas.vw_ventas

"""

query_base_order_view = """
    SELECT 
        id,
        cantidad AS quantity,
        costo AS cost,
        descuento AS discount,
        deposito AS warehouse,
        
        proveedor AS supplier,
        tipo_proveedor AS supplier_type,
        tasa AS tax_rate,
        
        fecha AS date,
        dia AS day,
        dia_semana AS weekday_number,
        nombre_dia AS weekday_name,
        semana_anio AS week_of_year,
        semana_mes AS week_of_month,
        quincena AS fortnight,
        mes AS month,
        nombre_mes AS month_name,
        trimestre AS quarter,
        semestre AS semester,
        anio AS year,
        es_fin_de_semana AS is_weekend,

        id_productos AS product_id,
        producto AS product_name,
        codigo AS product_code,
        categoria AS category,
        subcategoria AS subcategory,
        tipo_producto AS product_type,
        unidad AS unit,
        marca AS brand,
        detalles AS product_details,
        presentaciones AS product_presentations
    FROM compras.vw_ordenes
"""

query_base_purchase_view = """
    SELECT 
        id,
        cantidad AS quantity,
        costo AS cost,
        descuento AS discount,
        deposito AS warehouse,
        
        proveedor AS supplier,
        tipo_proveedor AS supplier_type,
        num_control AS control_number,
        num_factura AS invoice_number,
        tipo_factura AS invoice_type,
        tasa AS tax_rate,
        
        fecha AS date,
        dia AS day,
        dia_semana AS weekday_number,
        nombre_dia AS weekday_name,
        semana_anio AS week_of_year,
        semana_mes AS week_of_month,
        quincena AS fortnight,
        mes AS month,
        nombre_mes AS month_name,
        trimestre AS quarter,
        semestre AS semester,
        anio AS year,
        es_fin_de_semana AS is_weekend,
        
        -- Product breakdown
        id_productos AS product_id,
        producto AS product_name,
        codigo AS product_code,
        categoria AS category,
        subcategoria AS subcategory,
        tipo_producto AS product_type,
        unidad AS unit,
        marca AS brand,
        detalles AS product_details,
        presentaciones AS product_presentations,
        presentacion as presentation,
        modificador as modificator
    FROM compras.vw_compras
"""

query_base_quote_view = """
    SELECT 
        id,
        cantidad AS quantity,
        descuento AS discount,

        num_control AS control_number,
        tasa AS tax_rate,

        vendedor AS seller_name,
        porcentaje_vendedor AS seller_percentage,

        ciudad AS city,
        estado AS state,

        id_productos AS product_id,
        producto AS product_name,
        codigo AS product_code,
        categoria AS category,
        subcategoria AS subcategory,
        tipo_producto AS product_type,
        unidad AS unit,
        marca AS brand,
        detalles AS product_details,

        deposito AS warehouse,

        fecha AS date,
        dia AS day,
        dia_semana AS weekday_number,
        nombre_dia AS weekday_name,
        semana_anio AS week_of_year,
        semana_mes AS week_of_month,
        quincena AS fortnight,
        mes AS month,
        nombre_mes AS month_name,
        trimestre AS quarter,
        semestre AS semester,
        anio AS year,
        es_fin_de_semana AS is_weekend
    FROM ventas.vw_cotizaciones
"""


query_base_warehouse_view = """
    SELECT 
        id,
        deposito AS warehouse,
        tipo_movimiento AS movement_type,

        id_productos AS product_id,
        producto AS product_name,
        codigo AS product_code,
        categoria AS category,
        subcategoria AS subcategory,
        tipo_producto AS product_type,
        unidad AS unit,
        marca AS brand,
        detalles AS product_details,
        presentaciones AS presentaciones,

        cantidad AS quantity,

        fecha AS date,
        dia AS day,
        dia_semana AS weekday_number,
        nombre_dia AS weekday_name,
        semana_anio AS week_of_year,
        semana_mes AS week_of_month,
        quincena AS fortnight,
        mes AS month,
        nombre_mes AS month_name,
        trimestre AS quarter,
        semestre AS semester,
        anio AS year,
        es_fin_de_semana AS is_weekend
    FROM almacenes.vw_almacenes
"""

where_clause_warehouse_general = """
    WHERE 
        deposito ILIKE $1 OR 
        tipo_movimiento ILIKE $1 OR 
        producto ILIKE $1 OR
        codigo ILIKE $1 OR
        marca ILIKE $1 OR
        categoria ILIKE $1 OR
        subcategoria ILIKE $1 OR
        nombre_dia ILIKE $1 OR
        nombre_mes ILIKE $1
"""


where_clause_purchase_general = """
    WHERE 
        deposito ILIKE $1 OR 
        producto ILIKE $1 OR
        codigo ILIKE $1 OR
        marca ILIKE $1 OR
        categoria ILIKE $1 OR
        subcategoria ILIKE $1 OR
        nombre_dia ILIKE $1 OR
        nombre_mes ILIKE $1
"""

where_clause_sale_general = """
    WHERE 
        deposito ILIKE $1 OR 
        producto ILIKE $1 OR
        codigo ILIKE $1 OR
        marca ILIKE $1 OR
        categoria ILIKE $1 OR
        subcategoria ILIKE $1 OR
        nombre_dia ILIKE $1 OR
        nombre_mes ILIKE $1
"""


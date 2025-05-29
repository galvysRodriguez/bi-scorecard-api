
from datetime import datetime
from typing import Tuple, List, Any
from schemas.target import WarehouseFilter, ReportBase

def build_warehouse_filters(warehouse_data, ids=None, initial_index=1) -> Tuple[str, List[Any]]:
    conditions = []
    args = []
    index = initial_index

    def add_condition(condition: str, value):
        nonlocal index
        conditions.append(condition.replace("{}", f"${index}"))
        args.append(value)
        index += 1

    # Filtros generales
    if warehouse_data.warehouse:
        add_condition("deposito ILIKE {}", f"%{warehouse_data.warehouse}%")
    if warehouse_data.movement_type:
        add_condition("tipo_movimiento ILIKE {}", f"%{warehouse_data.movement_type}%")
    if warehouse_data.product_name:
        add_condition("producto ILIKE {}", f"%{warehouse_data.product_name}%")
    if warehouse_data.product_code:
        add_condition("codigo ILIKE {}", f"%{warehouse_data.product_code}%")
    if warehouse_data.category:
        add_condition("categoria ILIKE {}", f"%{warehouse_data.category}%")
    if warehouse_data.subcategory:
        add_condition("subcategoria ILIKE {}", f"%{warehouse_data.subcategory}%")
    if warehouse_data.product_type:
        add_condition("tipo_producto ILIKE {}", f"%{warehouse_data.product_type}%")
    if warehouse_data.unit:
        add_condition("unidad ILIKE {}", f"%{warehouse_data.unit}%")
    if warehouse_data.brand:
        add_condition("marca ILIKE {}", f"%{warehouse_data.brand}%")
    if warehouse_data.product_id:
        add_condition("id_productos = {}", warehouse_data.product_id)

    # Rango de cantidad
    if warehouse_data.quantity_min is not None:
        add_condition("cantidad >= {}", warehouse_data.quantity_min)
    if warehouse_data.quantity_max is not None:
        add_condition("cantidad <= {}", warehouse_data.quantity_max)

    # Fechas
    if warehouse_data.date_min:
        date_obj = datetime.strptime(warehouse_data.date_min, "%Y-%m-%d").date()
        add_condition("DATE(m.fecha) >= {}", date_obj)
    if warehouse_data.date_max:
        date_obj = datetime.strptime(warehouse_data.date_max, "%Y-%m-%d").date()
        add_condition("DATE(m.fecha) <= {}", date_obj)

    # Calendario
    if warehouse_data.day:
        add_condition("dia = {}", warehouse_data.day)
    if warehouse_data.weekday_number:
        add_condition("dia_semana = {}", warehouse_data.weekday_number)
    if warehouse_data.weekday_name:
        add_condition("nombre_dia ILIKE {}", f"%{warehouse_data.weekday_name}%")
    if warehouse_data.week_of_year:
        add_condition("semana_anio = {}", warehouse_data.week_of_year)
    if warehouse_data.week_of_month:
        add_condition("semana_mes = {}", warehouse_data.week_of_month)
    if warehouse_data.fortnight:
        add_condition("quincena = {}", warehouse_data.fortnight)
    if warehouse_data.month:
        add_condition("mes = {}", warehouse_data.month)
    if warehouse_data.month_name:
        add_condition("nombre_mes ILIKE {}", f"%{warehouse_data.month_name}%")
    if warehouse_data.quarter:
        add_condition("trimestre = {}", warehouse_data.quarter)
    if warehouse_data.semester:
        add_condition("semestre = {}", warehouse_data.semester)
    if warehouse_data.year:
        add_condition("anio = {}", warehouse_data.year)
    if warehouse_data.is_weekend is not None:
        add_condition("es_fin_de_semana = {}", warehouse_data.is_weekend)

    # Filtro por IDs
    if ids:
        add_condition("id = ANY({})", ids)

    where_clause = f"WHERE {' AND '.join(conditions)}" if conditions else ""
    return where_clause, args, index

def build_sale_filters(sales_data, ids=None, initial_index=1) -> Tuple[str, List[Any], int]:
    conditions = []
    args = []
    index = initial_index

    def add_condition(condition: str, value):
        nonlocal index
        conditions.append(condition.replace("{}", f"${index}"))
        args.append(value)
        index += 1

    # Filtros generales
    if sales_data.warehouse:
        add_condition("deposito ILIKE {}", f"%{sales_data.warehouse}%")
    if sales_data.invoice_type:
        add_condition("tipo_factura ILIKE {}", f"%{sales_data.invoice_type}%")
    if sales_data.product_name:
        add_condition("producto ILIKE {}", f"%{sales_data.product_name}%")
    if sales_data.product_code:
        add_condition("codigo ILIKE {}", f"%{sales_data.product_code}%")
    if sales_data.category:
        add_condition("categoria ILIKE {}", f"%{sales_data.category}%")
    if sales_data.subcategory:
        add_condition("subcategoria ILIKE {}", f"%{sales_data.subcategory}%")
    if sales_data.product_type:
        add_condition("tipo ILIKE {}", f"%{sales_data.product_type}%")
    if sales_data.unit:
        add_condition("unidad ILIKE {}", f"%{sales_data.unit}%")
    if sales_data.brand:
        add_condition("marca ILIKE {}", f"%{sales_data.brand}%")
    if sales_data.product_id:
        add_condition("id_productos = {}", sales_data.product_id)

    # Campos adicionales de SaleFilter
    if sales_data.control_number:
        add_condition("num_control ILIKE {}", f"%{sales_data.control_number}%")
    if sales_data.invoice_number:
        add_condition("num_factura ILIKE {}", f"%{sales_data.invoice_number}%")
    if sales_data.returned is not None:
        add_condition("devuelto = {}", sales_data.returned)
    if sales_data.city:
        add_condition("ciudad ILIKE {}", f"%{sales_data.city}%")
    if sales_data.state:
        add_condition("estado ILIKE {}", f"%{sales_data.state}%")
    if sales_data.seller_name:
        add_condition("nombre ILIKE {}", f"%{sales_data.seller_name}%")
    if sales_data.seller_percetage is not None:
        add_condition("porcentaje = {}", sales_data.seller_percetage)
    if sales_data.tax_rate is not None:
        add_condition("tasa = {}", sales_data.tax_rate)


    if sales_data.discount_min is not None:
        add_condition("descuento >= {}", sales_data.discount_min)
    if sales_data.discount_max is not None:
        add_condition("descuento <= {}", sales_data.discount_max)

    if sales_data.discount_bs_min is not None:
        add_condition("descuento_bs >= {}", sales_data.discount_bs_min)
    if sales_data.discount_bs_max is not None:
        add_condition("descuento_bs <= {}", sales_data.discount_bs_max)

    if sales_data.discount_percentage_min is not None:
        add_condition("descuento_porcentaje >= {}", sales_data.discount_percentage_min)
    if sales_data.discount_percentage_max is not None:
        add_condition("descuento_porcentaje <= {}", sales_data.discount_percentage_max)

    # Rango de cantidad
    if sales_data.discount_percentage_min is not None:
        add_condition("cantidad >= {}", sales_data.discount_percentage_min)
    if sales_data.discount_percentage_max is not None:
        add_condition("cantidad <= {}", sales_data.discount_percentage_max)

      # Rango de cantidad
    if sales_data.price_min is not None:
        add_condition("precio >= {}", sales_data.price_min)
    if sales_data.price_max is not None:
        add_condition("precio <= {}", sales_data.price_max)

    if sales_data.price_bs_min is not None:
        add_condition("precio_bs >= {}", sales_data.price_bs_min)
    if sales_data.price_bs_max is not None:
        add_condition("precio_bs <= {}", sales_data.price_bs_max)

    if sales_data.subtotal_min is not None:
        add_condition("subtotal >= {}", sales_data.subtotal_min)
    if sales_data.subtotal_max is not None:
        add_condition("subtotal <= {}", sales_data.subtotal_max)

    if sales_data.subtotal_bs_min is not None:
        add_condition("subtotal_bs >= {}", sales_data.subtotal_bs_min)
    if sales_data.subtotal_bs_max is not None:
        add_condition("subtotal_bs <= {}", sales_data.subtotal_bs_max)

    if sales_data.total_bs_min is not None:
        add_condition("total_bs >= {}", sales_data.total_bs_min)
    if sales_data.total_bs_max is not None:
        add_condition("total_bs <= {}", sales_data.total_bs_max)

    if sales_data.total_min is not None:
        add_condition("total >= {}", sales_data.total_min)
    if sales_data.total_max is not None:
        add_condition("total <= {}", sales_data.total_max)

    # Fechas
    if sales_data.date_min:
        date_obj = datetime.strptime(sales_data.date_min, "%Y-%m-%d").date()
        add_condition("DATE(fecha) >= {}", date_obj)
    if sales_data.date_max:
        date_obj = datetime.strptime(sales_data.date_max, "%Y-%m-%d").date()
        add_condition("DATE(fecha) <= {}", date_obj)

    # Calendario
    if sales_data.day:
        add_condition("dia = {}", sales_data.day)
    if sales_data.weekday_number:
        add_condition("dia_semana = {}", sales_data.weekday_number)
    if sales_data.weekday_name:
        add_condition("nombre_dia ILIKE {}", f"%{sales_data.weekday_name}%")
    if sales_data.week_of_year:
        add_condition("semana_anio = {}", sales_data.week_of_year)
    if sales_data.week_of_month:
        add_condition("semana_mes = {}", sales_data.week_of_month)
    if sales_data.fortnight:
        add_condition("quincena = {}", sales_data.fortnight)
    if sales_data.month:
        add_condition("mes = {}", sales_data.month)
    if sales_data.month_name:
        add_condition("nombre_mes ILIKE {}", f"%{sales_data.month_name}%")
    if sales_data.quarter:
        add_condition("trimestre = {}", sales_data.quarter)
    if sales_data.semester:
        add_condition("semestre = {}", sales_data.semester)
    if sales_data.year:
        add_condition("anio = {}", sales_data.year)
    if sales_data.is_weekend is not None:
        add_condition("es_fin_de_semana = {}", sales_data.is_weekend)

    if ids:
        add_condition("id = ANY({})", ids)

    where_clause = f"WHERE {' AND '.join(conditions)}" if conditions else ""
    return where_clause, args, index



def build_purchase_filters(purchase_data, ids=None, initial_index=1) -> Tuple[str, List[Any], int]:
    conditions = []
    args = []
    index = initial_index

    def add_condition(condition: str, value):
        nonlocal index
        conditions.append(condition.replace("{}", f"${index}"))
        args.append(value)
        index += 1

    # Filtros generales
    if purchase_data.warehouse:
        add_condition("deposito ILIKE {}", f"%{purchase_data.warehouse}%")
    if purchase_data.invoice_type:
        add_condition("tipo_factura ILIKE {}", f"%{purchase_data.invoice_type}%")
    if purchase_data.product_name:
        add_condition("producto ILIKE {}", f"%{purchase_data.product_name}%")
    if purchase_data.product_code:
        add_condition("codigo ILIKE {}", f"%{purchase_data.product_code}%")
    if purchase_data.category:
        add_condition("categoria ILIKE {}", f"%{purchase_data.category}%")
    if purchase_data.subcategory:
        add_condition("subcategoria ILIKE {}", f"%{purchase_data.subcategory}%")
    if purchase_data.product_type:
        add_condition("tipo_producto ILIKE {}", f"%{purchase_data.product_type}%")
    if purchase_data.unit:
        add_condition("unidad ILIKE {}", f"%{purchase_data.unit}%")
    if purchase_data.brand:
        add_condition("marca ILIKE {}", f"%{purchase_data.brand}%")
    if purchase_data.product_id:
        add_condition("id_productos = {}", purchase_data.product_id)

    # Campos adicionales de PurchaseFilter
    if purchase_data.control_number:
        add_condition("num_control ILIKE {}", f"%{purchase_data.control_number}%")
    if purchase_data.invoice_number:
        add_condition("num_factura ILIKE {}", f"%{purchase_data.invoice_number}%")
    if purchase_data.supplier:
        add_condition("proveedor ILIKE {}", f"%{purchase_data.supplier}%")
    if purchase_data.supplier_type:
        add_condition("tipo_proveedor ILIKE {}", f"%{purchase_data.supplier_type}%")

    if purchase_data.tax_rate is not None:
        add_condition("tasa = {}", purchase_data.tax_rate)

    if purchase_data.discount_min is not None:
        add_condition("descuento >= {}", purchase_data.discount_min)
    if purchase_data.discount_max is not None:
        add_condition("descuento <= {}", purchase_data.discount_max)

    if purchase_data.discount_bs_min is not None:
        add_condition("descuento_bs >= {}", purchase_data.discount_bs_min)
    if purchase_data.discount_bs_max is not None:
        add_condition("descuento_bs <= {}", purchase_data.discount_bs_max)

    if purchase_data.discount_percentage_min is not None:
        add_condition("descuento_porcentaje >= {}", purchase_data.discount_percentage_min)
    if purchase_data.discount_percentage_max is not None:
        add_condition("descuento_porcentaje <= {}", purchase_data.discount_percentage_max)

    # Rango de cantidad
    if purchase_data.discount_percentage_min is not None:
        add_condition("cantidad >= {}", purchase_data.discount_percentage_min)
    if purchase_data.discount_percentage_max is not None:
        add_condition("cantidad <= {}", purchase_data.discount_percentage_max)

      # Rango de cantidad
    if purchase_data.cost_min is not None:
        add_condition("costo >= {}", purchase_data.cost_min)
    if purchase_data.cost_max is not None:
        add_condition("costo <= {}", purchase_data.cost_max)

    if purchase_data.cost_bs_min is not None:
        add_condition("costo_bs >= {}", purchase_data.cost_bs_min)
    if purchase_data.cost_bs_max is not None:
        add_condition("costo_bs <= {}", purchase_data.cost_bs_max)

    if purchase_data.subtotal_min is not None:
        add_condition("subtotal >= {}", purchase_data.subtotal_min)
    if purchase_data.subtotal_max is not None:
        add_condition("subtotal <= {}", purchase_data.subtotal_max)

    if purchase_data.subtotal_bs_min is not None:
        add_condition("subtotal_bs >= {}", purchase_data.subtotal_bs_min)
    if purchase_data.subtotal_bs_max is not None:
        add_condition("subtotal_bs <= {}", purchase_data.subtotal_bs_max)

    if purchase_data.total_bs_min is not None:
        add_condition("total_bs >= {}", purchase_data.total_bs_min)
    if purchase_data.total_bs_max is not None:
        add_condition("total_bs <= {}", purchase_data.total_bs_max)

    if purchase_data.total_min is not None:
        add_condition("total >= {}", purchase_data.total_min)
    if purchase_data.total_max is not None:
        add_condition("total <= {}", purchase_data.total_max)

    # Fechas
    if purchase_data.date_min:
        date_obj = datetime.strptime(purchase_data.date_min, "%Y-%m-%d").date()
        add_condition("DATE(fecha) >= {}", date_obj)
    if purchase_data.date_max:
        date_obj = datetime.strptime(purchase_data.date_max, "%Y-%m-%d").date()
        add_condition("DATE(fecha) <= {}", date_obj)

    # Calendario
    if purchase_data.day:
        add_condition("dia = {}", purchase_data.day)
    if purchase_data.weekday_number:
        add_condition("dia_semana = {}", purchase_data.weekday_number)
    if purchase_data.weekday_name:
        add_condition("nombre_dia ILIKE {}", f"%{purchase_data.weekday_name}%")
    if purchase_data.week_of_year:
        add_condition("semana_anio = {}", purchase_data.week_of_year)
    if purchase_data.week_of_month:
        add_condition("semana_mes = {}", purchase_data.week_of_month)
    if purchase_data.fortnight:
        add_condition("quincena = {}", purchase_data.fortnight)
    if purchase_data.month:
        add_condition("mes = {}", purchase_data.month)
    if purchase_data.month_name:
        add_condition("nombre_mes ILIKE {}", f"%{purchase_data.month_name}%")
    if purchase_data.quarter:
        add_condition("trimestre = {}", purchase_data.quarter)
    if purchase_data.semester:
        add_condition("semestre = {}", purchase_data.semester)
    if purchase_data.year:
        add_condition("anio = {}", purchase_data.year)
    if purchase_data.is_weekend is not None:
        add_condition("es_fin_de_semana = {}", purchase_data.is_weekend)

    if ids:
        add_condition("id = ANY({})", ids)

    where_clause = f"WHERE {' AND '.join(conditions)}" if conditions else ""
    return where_clause, args, index


def build_order_filters(order_data, ids=None, initial_index=1) -> Tuple[str, List[Any], int]:
    conditions = []
    args = []
    index = initial_index

    def add_condition(condition: str, value):
        nonlocal index
        conditions.append(condition.replace("{}", f"${index}"))
        args.append(value)
        index += 1

    # Filtros generales
    if order_data.warehouse:
        add_condition("deposito ILIKE {}", f"%{order_data.warehouse}%")
    if order_data.product_name:
        add_condition("producto ILIKE {}", f"%{order_data.product_name}%")
    if order_data.product_code:
        add_condition("codigo ILIKE {}", f"%{order_data.product_code}%")
    if order_data.category:
        add_condition("categoria ILIKE {}", f"%{order_data.category}%")
    if order_data.subcategory:
        add_condition("subcategoria ILIKE {}", f"%{order_data.subcategory}%")
    if order_data.product_type:
        add_condition("tipo_producto ILIKE {}", f"%{order_data.product_type}%")
    if order_data.unit:
        add_condition("unidad ILIKE {}", f"%{order_data.unit}%")
    if order_data.brand:
        add_condition("marca ILIKE {}", f"%{order_data.brand}%")
    if order_data.product_id:
        add_condition("id_productos = {}", order_data.product_id)

    if order_data.supplier:
        add_condition("proveedor ILIKE {}", f"%{order_data.supplier}%")
    if order_data.supplier_type:
        add_condition("tipo_proveedor ILIKE {}", f"%{order_data.supplier_type}%")

    if order_data.tax_rate is not None:
        add_condition("tasa = {}", order_data.tax_rate)

    if order_data.discount_min is not None:
        add_condition("descuento >= {}", order_data.discount_min)
    if order_data.discount_max is not None:
        add_condition("descuento <= {}", order_data.discount_max)

    if order_data.discount_bs_min is not None:
        add_condition("descuento_bs >= {}", order_data.discount_bs_min)
    if order_data.discount_bs_max is not None:
        add_condition("descuento_bs <= {}", order_data.discount_bs_max)

    if order_data.discount_percentage_min is not None:
        add_condition("descuento_porcentaje >= {}", order_data.discount_percentage_min)
    if order_data.discount_percentage_max is not None:
        add_condition("descuento_porcentaje <= {}", order_data.discount_percentage_max)

    # Rango de cantidad
    if order_data.discount_percentage_min is not None:
        add_condition("cantidad >= {}", order_data.discount_percentage_min)
    if order_data.discount_percentage_max is not None:
        add_condition("cantidad <= {}", order_data.discount_percentage_max)

      # Rango de cantidad
    if order_data.cost_min is not None:
        add_condition("costo >= {}", order_data.cost_min)
    if order_data.cost_max is not None:
        add_condition("costo <= {}", order_data.cost_max)

    if order_data.cost_bs_min is not None:
        add_condition("costo_bs >= {}", order_data.cost_bs_min)
    if order_data.cost_bs_max is not None:
        add_condition("costo_bs <= {}", order_data.cost_bs_max)

    if order_data.subtotal_min is not None:
        add_condition("subtotal >= {}", order_data.subtotal_min)
    if order_data.subtotal_max is not None:
        add_condition("subtotal <= {}", order_data.subtotal_max)

    if order_data.subtotal_bs_min is not None:
        add_condition("subtotal_bs >= {}", order_data.subtotal_bs_min)
    if order_data.subtotal_bs_max is not None:
        add_condition("subtotal_bs <= {}", order_data.subtotal_bs_max)

    if order_data.total_bs_min is not None:
        add_condition("total_bs >= {}", order_data.total_bs_min)
    if order_data.total_bs_max is not None:
        add_condition("total_bs <= {}", order_data.total_bs_max)

    if order_data.total_min is not None:
        add_condition("total >= {}", order_data.total_min)
    if order_data.total_max is not None:
        add_condition("total <= {}", order_data.total_max)

    # Fechas
    if order_data.date_min:
        date_obj = datetime.strptime(order_data.date_min, "%Y-%m-%d").date()
        add_condition("DATE(fecha) >= {}", date_obj)
    if order_data.date_max:
        date_obj = datetime.strptime(order_data.date_max, "%Y-%m-%d").date()
        add_condition("DATE(fecha) <= {}", date_obj)

    # Calendario
    if order_data.day:
        add_condition("dia = {}", order_data.day)
    if order_data.weekday_number:
        add_condition("dia_semana = {}", order_data.weekday_number)
    if order_data.weekday_name:
        add_condition("nombre_dia ILIKE {}", f"%{order_data.weekday_name}%")
    if order_data.week_of_year:
        add_condition("semana_anio = {}", order_data.week_of_year)
    if order_data.week_of_month:
        add_condition("semana_mes = {}", order_data.week_of_month)
    if order_data.fortnight:
        add_condition("quincena = {}", order_data.fortnight)
    if order_data.month:
        add_condition("mes = {}", order_data.month)
    if order_data.month_name:
        add_condition("nombre_mes ILIKE {}", f"%{order_data.month_name}%")
    if order_data.quarter:
        add_condition("trimestre = {}", order_data.quarter)
    if order_data.semester:
        add_condition("semestre = {}", order_data.semester)
    if order_data.year:
        add_condition("anio = {}", order_data.year)
    if order_data.is_weekend is not None:
        add_condition("es_fin_de_semana = {}", order_data.is_weekend)

    if ids:
        add_condition("id = ANY({})", ids)

    where_clause = f"WHERE {' AND '.join(conditions)}" if conditions else ""
    return where_clause, args, index


def build_quote_filters(quote_data, ids=None, initial_index=1) -> Tuple[str, List[Any], int]:
    conditions = []
    args = []
    index = initial_index

    def add_condition(condition: str, value):
        nonlocal index
        conditions.append(condition.replace("{}", f"${index}"))
        args.append(value)
        index += 1

    # Filtros generales
    if quote_data.warehouse:
        add_condition("deposito ILIKE {}", f"%{quote_data.warehouse}%")
    if quote_data.product_name:
        add_condition("producto ILIKE {}", f"%{quote_data.product_name}%")
    if quote_data.product_code:
        add_condition("codigo ILIKE {}", f"%{quote_data.product_code}%")
    if quote_data.category:
        add_condition("categoria ILIKE {}", f"%{quote_data.category}%")
    if quote_data.subcategory:
        add_condition("subcategoria ILIKE {}", f"%{quote_data.subcategory}%")
    if quote_data.product_type:
        add_condition("tipo ILIKE {}", f"%{quote_data.product_type}%")
    if quote_data.unit:
        add_condition("unidad ILIKE {}", f"%{quote_data.unit}%")
    if quote_data.brand:
        add_condition("marca ILIKE {}", f"%{quote_data.brand}%")
    if quote_data.product_id:
        add_condition("id_productos = {}", quote_data.product_id)

    if quote_data.city:
        add_condition("ciudad ILIKE {}", f"%{quote_data.city}%")
    if quote_data.state:
        add_condition("estado ILIKE {}", f"%{quote_data.state}%")
    if quote_data.seller_name:
        add_condition("nombre ILIKE {}", f"%{quote_data.seller_name}%")
    if quote_data.seller_percetage is not None:
        add_condition("porcentaje = {}", quote_data.seller_percetage)
    if quote_data.tax_rate is not None:
        add_condition("tasa = {}", quote_data.tax_rate)


    if quote_data.discount_min is not None:
        add_condition("descuento >= {}", quote_data.discount_min)
    if quote_data.discount_max is not None:
        add_condition("descuento <= {}", quote_data.discount_max)

    if quote_data.discount_bs_min is not None:
        add_condition("descuento_bs >= {}", quote_data.discount_bs_min)
    if quote_data.discount_bs_max is not None:
        add_condition("descuento_bs <= {}", quote_data.discount_bs_max)

    if quote_data.discount_percentage_min is not None:
        add_condition("descuento_porcentaje >= {}", quote_data.discount_percentage_min)
    if quote_data.discount_percentage_max is not None:
        add_condition("descuento_porcentaje <= {}", quote_data.discount_percentage_max)

    # Rango de cantidad
    if quote_data.discount_percentage_min is not None:
        add_condition("cantidad >= {}", quote_data.discount_percentage_min)
    if quote_data.discount_percentage_max is not None:
        add_condition("cantidad <= {}", quote_data.discount_percentage_max)

      # Rango de cantidad
    if quote_data.price_min is not None:
        add_condition("precio >= {}", quote_data.price_min)
    if quote_data.price_max is not None:
        add_condition("precio <= {}", quote_data.price_max)

    if quote_data.price_bs_min is not None:
        add_condition("precio_bs >= {}", quote_data.price_bs_min)
    if quote_data.price_bs_max is not None:
        add_condition("precio_bs <= {}", quote_data.price_bs_max)

    if quote_data.subtotal_min is not None:
        add_condition("subtotal >= {}", quote_data.subtotal_min)
    if quote_data.subtotal_max is not None:
        add_condition("subtotal <= {}", quote_data.subtotal_max)

    if quote_data.subtotal_bs_min is not None:
        add_condition("subtotal_bs >= {}", quote_data.subtotal_bs_min)
    if quote_data.subtotal_bs_max is not None:
        add_condition("subtotal_bs <= {}", quote_data.subtotal_bs_max)

    if quote_data.total_bs_min is not None:
        add_condition("total_bs >= {}", quote_data.total_bs_min)
    if quote_data.total_bs_max is not None:
        add_condition("total_bs <= {}", quote_data.total_bs_max)

    if quote_data.total_min is not None:
        add_condition("total >= {}", quote_data.total_min)
    if quote_data.total_max is not None:
        add_condition("total <= {}", quote_data.total_max)

    # Fechas
    if quote_data.date_min:
        date_obj = datetime.strptime(quote_data.date_min, "%Y-%m-%d").date()
        add_condition("DATE(fecha) >= {}", date_obj)
    if quote_data.date_max:
        date_obj = datetime.strptime(quote_data.date_max, "%Y-%m-%d").date()
        add_condition("DATE(fecha) <= {}", date_obj)

    # Calendario
    if quote_data.day:
        add_condition("dia = {}", quote_data.day)
    if quote_data.weekday_number:
        add_condition("dia_semana = {}", quote_data.weekday_number)
    if quote_data.weekday_name:
        add_condition("nombre_dia ILIKE {}", f"%{quote_data.weekday_name}%")
    if quote_data.week_of_year:
        add_condition("semana_anio = {}", quote_data.week_of_year)
    if quote_data.week_of_month:
        add_condition("semana_mes = {}", quote_data.week_of_month)
    if quote_data.fortnight:
        add_condition("quincena = {}", quote_data.fortnight)
    if quote_data.month:
        add_condition("mes = {}", quote_data.month)
    if quote_data.month_name:
        add_condition("nombre_mes ILIKE {}", f"%{quote_data.month_name}%")
    if quote_data.quarter:
        add_condition("trimestre = {}", quote_data.quarter)
    if quote_data.semester:
        add_condition("semestre = {}", quote_data.semester)
    if quote_data.year:
        add_condition("anio = {}", quote_data.year)
    if quote_data.is_weekend is not None:
        add_condition("es_fin_de_semana = {}", quote_data.is_weekend)

    if ids:
        add_condition("id = ANY({})", ids)

    where_clause = f"WHERE {' AND '.join(conditions)}" if conditions else ""
    return where_clause, args, index

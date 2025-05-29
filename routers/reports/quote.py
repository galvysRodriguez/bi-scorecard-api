from fastapi import APIRouter, Depends, Query
from asyncpg import Connection
from decimal import Decimal
from typing import List, Optional
from services.reports.quote_service import get_simple_quote, get_search_column_quote, get_filter_column_quote, validation_order_by, validation_order_dir
from db.database import get_db
from schemas.target import QuoteFilter, ReportBase
from utils.api_response import api_response

router = APIRouter(prefix="/reports/quote", tags=["/reports/quote"])


@router.get("/")
async def get_quote_grouped(
    warehouse: Optional[str] = None,
    city: Optional[str] = None,
    state: Optional[str] = None,
    customer_name: Optional[str] = None,
    customer_type: Optional[str] = None,
    customer_address: Optional[str] = None,
    customer_commercial: Optional[str] = None,
    seller_name: Optional[str] = None,
    seller_percetage: Optional[Decimal] = None,
    price_min: Optional[Decimal] = None,
    price_bs_min: Optional[Decimal] = None,
    discount_bs_min: Optional[Decimal] = None,
    discount_percentage_min: Optional[Decimal] = None,
    subtotal_min: Optional[Decimal] = None,
    subtotal_bs_min: Optional[Decimal] = None,
    total_min: Optional[Decimal] = None,
    total_bs_min: Optional[Decimal] = None,
    discount_min: Optional[Decimal] = None,
    price_max: Optional[Decimal] = None,
    price_bs_max: Optional[Decimal] = None,
    discount_bs_max: Optional[Decimal] = None,
    discount_percentage_max: Optional[Decimal] = None,
    subtotal_max: Optional[Decimal] = None,
    subtotal_bs_max: Optional[Decimal] = None,
    total_max: Optional[Decimal] = None,
    total_bs_max: Optional[Decimal] = None,
    discount_max: Optional[Decimal] = None,
    tax_rate: Optional[Decimal] = None,
    product_name: Optional[str] = None,
    product_code: Optional[str] = None,
    category: Optional[str] = None,
    subcategory: Optional[str] = None,
    product_type: Optional[str] = None,
    unit: Optional[str] = None,
    brand: Optional[str] = None,
    quantity_min: Optional[int] = None,
    quantity_max: Optional[int] = None,
    date_min: Optional[str] = None,
    date_max: Optional[str] = None,
    day: Optional[int] = None,
    weekday_number: Optional[int] = None,
    weekday_name: Optional[str] = None,
    week_of_year: Optional[int] = None,
    week_of_month: Optional[int] = None,
    fortnight: Optional[int] = None,
    month: Optional[int] = None,
    month_name: Optional[str] = None,
    quarter: Optional[int] = None,
    semester: Optional[int] = None,
    year: Optional[int] = None,
    is_weekend: Optional[bool] = None,
    search: Optional[str] = None,
    order_by: Optional[str] = "id",
    order_dir: Optional[str] = "asc",
    limit: int = Query(10, ge=1, le=10000),
    offset: int = Query(0, ge=0),
    db: Connection = Depends(get_db)
):
    order_by = validation_order_by(order_by)
    if not order_by:
        return api_response("Columna a ordenar invalida", False)

    order_dir = validation_order_dir(order_dir)
    if not order_dir:
        return api_response("Direccion a ordenar invalida", False)

    report_base = ReportBase(order_by=order_by, order_dir=order_dir, limit=limit, offset=offset)

    filters = QuoteFilter(
        warehouse=warehouse,
        city=city,
        state=state,
        customer_name=customer_name,
        customer_type=customer_type,
        customer_address=customer_address,
        customer_commercial=customer_commercial,
        seller_name=seller_name,
        seller_percetage=seller_percetage,
        tax_rate=tax_rate,
        discount_min=discount_min,
        discount_max=discount_max,
        product_name=product_name,
        product_code=product_code,
        category=category,
        subcategory=subcategory,
        product_type=product_type,
        unit=unit,
        brand=brand,

        quantity_min=quantity_min,
        quantity_max=quantity_max,

        price_min=price_min,
        price_max=price_max,

        price_bs_min=price_bs_min,
        price_bs_max=price_bs_max,

        discount_bs_min=discount_bs_min,
        discount_bs_max=discount_bs_max,

        discount_percentage_min=discount_percentage_min,
        discount_percentage_max=discount_percentage_max,

        subtotal_min=subtotal_min,
        subtotal_max=subtotal_max,

        subtotal_bs_min=subtotal_bs_min,
        subtotal_bs_max=subtotal_bs_max,

        total_min=total_min,
        total_max=total_max,

        total_bs_min=total_bs_min,
        total_bs_max=total_bs_max,

        date_min=date_min,
        date_max=date_max,
        day=day,
        weekday_number=weekday_number,
        weekday_name=weekday_name,
        week_of_year=week_of_year,
        week_of_month=week_of_month,
        fortnight=fortnight,
        month=month,
        month_name=month_name,
        quarter=quarter,
        semester=semester,
        year=year,
        is_weekend=is_weekend
    )


    def has_filters(filter_obj: QuoteFilter) -> bool:
        return any(value is not None for value in filter_obj.dict(exclude_none=True).values())

    if has_filters(filters):
        return await get_filter_column_quote(db, report_base, filters, search)

    if search:
        return await get_search_column_quote(db, search, report_base)

    return await get_simple_quote(db, report_base)

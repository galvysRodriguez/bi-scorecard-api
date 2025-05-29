from pydantic import BaseModel, Field
from typing import Optional
from decimal import Decimal
from datetime import datetime
import pytz


def get_current_datetime():
    """Obtiene la fecha y hora actual en la zona horaria de Venezuela, pero la devuelve sin offset."""
    tz = pytz.timezone("America/Caracas")
    return datetime.now(tz).replace(tzinfo=None)

class FormulaBase(BaseModel):
    title: str
    
class FormulaCreate(FormulaBase):
    tag_id: int
    formula: str

class TagBase(BaseModel):
    title: str

class IconBase(BaseModel):
    title: str

class UserBase(BaseModel):
    user: str
    password: str

class PerspectiveBase(BaseModel):
    title: str

class PerspectiveCreate(PerspectiveBase):
    tags: list[int]
    icon_id: Optional[int] = None

class TagCreate(TagBase):
    perspectives: list[int]
    indicators: list[int]

class TargetBase(BaseModel):
    title: str

class TargetCreate(TargetBase):
    optimal: Optional[float] = None
    tolerable: Optional[float] = None
    deficient: Optional[float] = None
    start_date: Optional[datetime] = Field(default_factory=get_current_datetime) 
    end_date: Optional[datetime] = None  
    formula_id: Optional[int] = None


class TargetUpdate(BaseModel):
    title: Optional[str] = None
    optimal: Optional[float] = None
    tolerable: Optional[float] = None
    deficient: Optional[float] = None
    start_date: Optional[datetime] = Field(default_factory=get_current_datetime)  
    end_date: Optional[datetime] = None  
    perspective_id: Optional[int] = None
    indicator_id: Optional[int] = None


class TargetResponse(BaseModel):
    id: int = Field(..., alias="id_objetivos")
    title: str = Field(..., alias="titulo")
    optimal: Decimal = Field(..., alias="optimo")
    tolerable: Optional[Decimal] = Field(None, alias="tolerable")
    deficient: Optional[Decimal] = Field(None, alias="deficiente")
    perspective_id: int = Field(..., alias="id_perspectivas")
    formula_id: Optional[int] = Field(None, alias="id_formulas")
    start_date: Optional[datetime] = Field(None, alias="id_fecha_inicio") 
    end_date: Optional[datetime] = Field(None, alias="id_fecha_final")  
    completion_date: Optional[datetime] = Field(None, alias="fecha_culminacion")  

    class Config:
        from_attributes = True
        populate_by_name = True

class Token(BaseModel):
    access_token: str
    token_type: str


class UserBase(BaseModel):
    username: str
    hashed_password: Optional[str] = None

class PermissionBase(BaseModel):
    resource: str
    action: str 

class User(BaseModel):
    id: int
    username: str
    email: str
    hashed_password: str

class TableProcessSchema(BaseModel):
    source_table: str
    target_table: str
    schema_name: str
    query: str

class DateFilter(BaseModel):
    date_min: Optional[str] = None
    date_max: Optional[str] = None
    day: Optional[int] = None
    weekday_number: Optional[int] = None
    weekday_name: Optional[str] = None
    week_of_year: Optional[int] = None
    week_of_month: Optional[int] = None
    fortnight: Optional[int] = None
    month: Optional[int] = None
    month_name: Optional[str] = None
    quarter: Optional[int] = None
    semester: Optional[int] = None
    year: Optional[int] = None
    is_weekend: Optional[bool] = None

class QuantityFilter(BaseModel):
    quantity_min: Optional[int] = None
    quantity_max: Optional[int] = None

class ProductFilter(BaseModel):
    product_id: Optional[int] = None
    product_name: Optional[str] = None
    product_code: Optional[str] = None
    category: Optional[str] = None
    subcategory: Optional[str] = None
    product_type: Optional[str] = None
    unit: Optional[str] = None
    brand: Optional[str] = None

class TotalFilter():
    total_min: Optional[Decimal] = None
    total_max: Optional[Decimal] = None
    total_bs_min: Optional[Decimal] = None
    total_bs_max: Optional[Decimal] = None
    discount_percentage_min: Optional[Decimal] = None
    discount_percentage_max: Optional[Decimal] = None
    discount_bs_min: Optional[Decimal] = None
    discount_bs_max: Optional[Decimal] = None
    discount_min: Optional[Decimal] = None
    discount_max: Optional[Decimal] = None
    subtotal_min: Optional[Decimal] = None
    subtotal_max: Optional[Decimal] = None
    subtotal_bs_min: Optional[Decimal] = None
    subtotal_bs_max: Optional[Decimal] = None

class WarehouseFilter(ProductFilter, QuantityFilter, DateFilter):
    warehouse: Optional[str] = None
    movement_type: Optional[str] = None

class OrderFilter(ProductFilter, QuantityFilter, DateFilter, TotalFilter):
    warehouse: Optional[str] = None
    supplier: Optional[str] = None
    supplier_type: Optional[str] = None
    cost_min: Optional[Decimal] = None
    cost_bs_min: Optional[Decimal] = None
    cost_max: Optional[Decimal] = None
    cost_bs_max: Optional[Decimal] = None
    tax_rate: Optional[Decimal] = None

class QuoteFilter(ProductFilter, QuantityFilter, DateFilter, TotalFilter):
    customer_name: Optional[str] = None
    customer_type: Optional[str] = None
    customer_commercial: Optional[str] = None
    customer_address: Optional[str] = None
    warehouse: Optional[str] = None
    city: Optional[str] = None
    state: Optional[str] = None
    seller_name: Optional[str] = None
    seller_percetage: Optional[Decimal] = None
    price_min: Optional[Decimal] = None
    price_max: Optional[Decimal] = None
    price_bs_min: Optional[Decimal] = None
    price_bs_max: Optional[Decimal] = None
    tax_rate: Optional[Decimal] = None
    control_number: Optional[str] = None

class SaleFilter(QuoteFilter):
    invoice_number: Optional[str] = None
    invoice_type: Optional[str] = None
    returned: Optional[Decimal] = None

class PurchaseFilter(OrderFilter):
    control_number: Optional[str] = None
    invoice_number: Optional[str] = None
    invoice_type: Optional[str] = None

class ReportBase(BaseModel):
    order_by: Optional[str] = None
    order_dir: Optional[str] = None
    limit: Optional[int] = None
    offset: Optional[int] = None

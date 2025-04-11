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
    start_date: Optional[datetime] = Field(default_factory=get_current_datetime)  # Timestamp de inicio
    end_date: Optional[datetime] = None  # Timestamp de finalización
    formula_id: Optional[int] = None


class TargetUpdate(BaseModel):
    title: Optional[str] = None
    optimal: Optional[float] = None
    tolerable: Optional[float] = None
    deficient: Optional[float] = None
    start_date: Optional[datetime] = Field(default_factory=get_current_datetime)  # Timestamp de inicio
    end_date: Optional[datetime] = None  # Timestamp de finalización
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
    start_date: Optional[datetime] = Field(None, alias="id_fecha_inicio")  # Timestamp
    end_date: Optional[datetime] = Field(None, alias="id_fecha_final")  # Timestamp
    completion_date: Optional[datetime] = Field(None, alias="fecha_culminacion")  # Timestamp

    class Config:
        from_attributes = True
        populate_by_name = True

from pydantic import BaseModel, Field
from typing import Optional
from decimal import Decimal
from datetime import datetime
import pytz


def get_current_datetime():
    """Obtiene la fecha y hora actual en la zona horaria de Venezuela, pero la devuelve sin offset."""
    tz = pytz.timezone("America/Caracas")
    return datetime.now(tz).replace(tzinfo=None)

class TargetBase(BaseModel):
    title: str
    optimal: float
    tolerable: Optional[float] = None
    deficient: Optional[float] = None
    start_date: Optional[datetime] = Field(default_factory=get_current_datetime)  # Timestamp de inicio
    end_date: Optional[datetime] = None  # Timestamp de finalización
    indicator_id: int
    aggregation_id: Optional[int] = None


class TargetCreate(TargetBase):
    pass


class TargetUpdate(TargetBase):
    title: Optional[str] = None  # Permitir actualización parcial


class TargetResponse(BaseModel):
    id: int = Field(..., alias="id_objetivos")
    title: str = Field(..., alias="titulo")
    optimal: Decimal = Field(..., alias="optimo")
    tolerable: Optional[Decimal] = Field(None, alias="tolerable")
    deficient: Optional[Decimal] = Field(None, alias="deficiente")
    indicator_id: int = Field(..., alias="id_indicadores")
    aggregation_id: Optional[int] = Field(None, alias="id_agregaciones")
    start_date: Optional[datetime] = Field(None, alias="id_fecha_inicio")  # Timestamp
    end_date: Optional[datetime] = Field(None, alias="id_fecha_final")  # Timestamp
    completion_date: Optional[datetime] = Field(None, alias="fecha_culminacion")  # Timestamp

    class Config:
        from_attributes = True
        populate_by_name = True

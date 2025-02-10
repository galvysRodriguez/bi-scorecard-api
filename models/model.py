from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class AgregacionModel(BaseModel):
    id_agregaciones: int
    agregacion: str

class PerspectivaModel(BaseModel):
    id_perspectivas: int
    perspectiva: str

class IndicadorModel(BaseModel):
    id_indicadores: int
    indicador: str
    id_perspectivas: int
    consulta: Optional[str] = None

class ObjetivoModel(BaseModel):
    id_objetivos: int
    titulo: str
    optimo: float
    tolerable: Optional[float] = None
    deficiente: Optional[float] = None
    fecha_inicio: Optional[datetime] = None
    fecha_final: Optional[datetime] = None
    id_indicadores: int
    id_agregaciones: Optional[int] = None
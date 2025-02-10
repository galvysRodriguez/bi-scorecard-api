from datetime import datetime

class Agregacion:
    def __init__(self, id_agregaciones: int, agregacion: str):
        self.id_agregaciones = id_agregaciones
        self.agregacion = agregacion

class Perspectiva:
    def __init__(self, id_perspectivas: int, perspectiva: str):
        self.id_perspectivas = id_perspectivas
        self.perspectiva = perspectiva

class Indicador:
    def __init__(self, id_indicadores: int, indicador: str, id_perspectivas: int, consulta: Optional[str] = None):
        self.id_indicadores = id_indicadores
        self.indicador = indicador
        self.id_perspectivas = id_perspectivas
        self.consulta = consulta

class Objetivo:
    def __init__(self, id_objetivos: int, titulo: str, optimo: float, tolerable: Optional[float], deficiente: Optional[float], fecha_inicio: Optional[datetime], fecha_final: Optional[datetime], id_indicadores: int, id_agregaciones: Optional[int]):
        self.id_objetivos = id_objetivos
        self.titulo = titulo
        self.optimo = optimo
        self.tolerable = tolerable
        self.deficiente = deficiente
        self.id_fecha_inicio = id_fecha_inicio
        self.id_fecha_final = id_fecha_final
        self.id_indicadores = id_indicadores
        self.id_agregaciones = id_agregaciones
from asyncpg import Connection
from datetime import datetime
from repositories.target_repo import TargetRepository
from schemas.target import TargetCreate, TargetUpdate
from utils.api_response import api_response
from services.indicator_service import fetch_indicator_value
from services.formula_service import calc_formula_date, calc_formula_grouped
import pandas as pd


class TargetService:
    @staticmethod
    async def get_target(db: Connection, target_id: int):
        """Obtiene un objetivo y lo convierte a respuesta de API."""
        row = await TargetRepository.get_target(db, target_id)
        if not row:
            return api_response("Target not found", False)

        
        indicator_value = await calc_formula_date(
            db, 
            row["indicator_id"], 
            row["start_date"],
            row["end_date"])

        target_data = {
                "id": row["id"],
                "title": row["title"],
                "optimal": row["optimal"],
                "tolerable": row["tolerable"],
                "deficient": row["deficient"],
                "indicator_id": row["indicator_id"],
                "perspective_id": row["perspective_id"],
                "start_date": row["start_date"],
                "end_date": row["end_date"],
                "indicator": row["indicator"],
                "perspective": row["perspective"],
                "indicator_value": indicator_value.get("data", {}).get("value")  # Extraer el valor si está disponible
            }
    

        return api_response("Target retrieved successfully", True, dict(target_data))

    async def get_detail_target(db: Connection, target_id: int):
        """Obtiene un objetivo y lo convierte a respuesta de API con desglose por fechas."""
        row = await TargetRepository.get_target(db, target_id)
        if not row:
            return api_response("Target not found", False)

        # Obtener los valores calculados según el indicador
        indicator_value = await calc_formula_grouped(
            db, 
            row["indicator_id"], 
            row["start_date"],
            row["end_date"],
            row["optimal"]
        )

        df = pd.DataFrame(indicator_value)
        df["cumulative"] = round(df["value"].cumsum(),2)
        min_daily = round(row["optimal"] / len(df),2)
        df = df.tail(10)
        result = df.to_dict(orient="records")
        total_value = sum(map(lambda x: x["value"], indicator_value))

        start_date = row["start_date"]
        end_date = row["end_date"]
        today = datetime.today()

        # Calcular días transcurridos y restantes
        elapsed = (today - start_date).days
        restant = (end_date - today).days

        # Asegurar que no haya valores negativos
        elapsed = max(elapsed, 0)
        restant = max(restant, 0)



        # Datos generales del objetivo
        target_data = {
            "id": row["id"],
            "title": row["title"],
            "optimal": row["optimal"],
            "tolerable": row["tolerable"],
            "deficient": row["deficient"],
            "indicator_id": row["indicator_id"],
            "perspective_id": row["perspective_id"],
            "start_date": row["start_date"],
            "end_date": row["end_date"],
            "elapsed": elapsed,
            "restant": restant,
            "indicator": row["indicator"],
            "perspective": row["perspective"],
            "min_daily": min_daily,
            "indicator_value": total_value, 
            "detail": result
        }

        return api_response("Target retrieved successfully", True, target_data)


    @staticmethod
    async def get_targets(db: Connection, perspective_id: int):
        """Obtiene todos los objetivos y los devuelve como respuesta."""
        targets = await TargetRepository.get_targets(db, perspective_id)
        if not targets:
            return api_response("Targets not found", False)

        response_data = []
        
        for target in targets:
            indicator_value = await calc_formula_date(
                db, 
                target["indicator_id"], 
                target["start_date"],
                target["end_date"])
            
            # Agregar el valor del indicador a la respuesta
            target_data = {
                "id": target["id"],
                "title": target["title"],
                "optimal": target["optimal"],
                "tolerable": target["tolerable"],
                "deficient": target["deficient"],
                "indicator_id": target["indicator_id"],
                "perspecitve_id": target["perspective_id"],
                "start_date": target["start_date"],
                "end_date": target["end_date"],
                "indicator": target["indicator"],
                "perspective": target["perspective"],
                "indicator_value": indicator_value.get("data", {}).get("value")  # Extraer el valor si está disponible
            }
            
            response_data.append(target_data)

        return api_response("Targets retrieved", True, response_data)

    @staticmethod
    async def get_all_targets(db: Connection):
        """Obtiene todos los objetivos y los devuelve como respuesta."""
        targets = await TargetRepository.get_all_targets(db)
        
        if not targets:
            return api_response("Targets not found", False)

        response_data = []
        
        for target in targets:
            indicator_value = await calc_formula_date(
                db, 
                target["indicator_id"], 
                target["start_date"],
                target["end_date"])
            
            # Agregar el valor del indicador a la respuesta
            target_data = {
                "id": target["id"],
                "title": target["title"],
                "optimal": target["optimal"],
                "tolerable": target["tolerable"],
                "deficient": target["deficient"],
                "indicator_id": target["indicator_id"],
                "perspecitve_id": target["perspective_id"],
                "start_date": target["start_date"],
                "end_date": target["end_date"],
                "indicator": target["indicator"],
                "perspective": target["perspective"],
                "indicator_value": indicator_value.get("data", {}).get("value")  # Extraer el valor si está disponible
            }
            
            response_data.append(target_data)

        return api_response("Targets retrieved", True, response_data)


    @staticmethod
    async def add_target(db: Connection, target_data: TargetCreate):
        """Crea un nuevo objetivo y devuelve su respuesta."""
        row = await TargetRepository.add_target(db, target_data)
        return api_response("Target created successfully", True, dict(row))

    @staticmethod
    async def update_target(db: Connection, target_id: int, update_data:TargetUpdate):
        """Actualiza un objetivo existente."""
        row = await TargetRepository.update_target(db, target_id, update_data)
        if not row:
            return api_response("Target not found", False)
        return api_response("Target updated successfully", True, dict(row))

    @staticmethod
    async def delete_target(db: Connection, target_id: int):
        """Elimina un objetivo por ID."""
        row = await TargetRepository.delete_target(db, target_id)
        if not row:
            return api_response("Target not found", False)
        return api_response("Target deleted successfully", True, dict(row))

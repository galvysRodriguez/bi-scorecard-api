from asyncpg import Connection
from datetime import datetime
from repositories.target_repo import TargetRepository
from schemas.target import TargetCreate, TargetUpdate, TargetBase
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
                "indicator_id": row["formula_id"],
                "perspective_id": row["perspective_id"],
                "start_date": row["start_date"],
                "end_date": row["end_date"],
                "indicator": row["formula"],
                "perspective": row["perspective"],
                "tag": row["tag"],
                "tag_id": row["tag_id"],
                "indicator_value": indicator_value.get("data", {}).get("value")  # Extraer el valor si está disponible
            }
    

        return api_response("Target retrieved successfully", True, dict(target_data))
    
    async def get_target_simple(db: Connection, target_id: int):
        """Obtiene un objetivo y lo convierte a respuesta de API."""
        row = await TargetRepository.get_target(db, target_id)
        if not row:
            return api_response("Target not found", False)

        return api_response("Target retrieved successfully", True, row)

    async def get_detail_target(db: Connection, target_id: int):
        row = await TargetRepository.get_target(db, target_id)
        if not row:
            return api_response("Target not found", False)

        indicator_response = await calc_formula_grouped(
            db,
            row["formula_id"],
            row["start_date"],
            row["end_date"],
            row["optimal"]
        )

        indicator_prev = {"data": {"values": indicator_response}}
        indicator_values = indicator_prev.get("data", {}).get("values", [])

        if not indicator_values:
            return api_response("No indicator data found", True, {
                "id": row["id"],
                "title": row["title"],
                "optimal": row["optimal"],
                "tolerable": row["tolerable"],
                "deficient": row["deficient"],
                "indicator_id": row["formula_id"],
                "perspective_id": row["perspective_id"],
                "start_date": row["start_date"],
                "tag": row["tag"],
                "tag_id": row["tag_id"],
                "end_date": row["end_date"],
                "elapsed": 0,
                "restant": 0,
                "indicator": row["formula"],
                "perspective": row["perspective"],
                "min_daily": 0,
                "indicator_value": 0,
                "detail": []
            })

        df = pd.DataFrame(indicator_values)
        df["cumulative"] = df["value"].cumsum().round(2)
        min_daily = round(row["optimal"] / len(df), 2)
        df = df.tail(10)
        result = df.to_dict(orient="records")

        value_response = await calc_formula_date(
            db,
            row["formula_id"],
            row["start_date"],
            row["end_date"]
        )

        total_value = round(value_response.get("data", {}).get("value", 0), 2)

        today = datetime.today()
        elapsed = max((today - row["start_date"]).days, 0)
        restant = max((row["end_date"] - today).days, 0)

        target_data = {
            "id": row["id"],
            "title": row["title"],
            "optimal": row["optimal"],
            "tolerable": row["tolerable"],
            "deficient": row["deficient"],
            "indicator_id": row["formula_id"],
            "perspective_id": row["perspective_id"],
            "start_date": row["start_date"],
            "end_date": row["end_date"],
            "elapsed": elapsed,
            "restant": restant,
            "indicator": row["formula"],
            "perspective": row["perspective"],
            "tag": row["tag"],
            "tag_id": row["tag_id"],
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
                "tag": target["tag"],
                "tag_id": target["tag_id"],
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
                "tag": target["tag"],
                "tag_id": target["tag_id"],
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
    async def update_target(db: Connection, target_id: int, update_data:TargetCreate):
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
    

    @staticmethod
    async def exist_target(db: Connection, target:TargetBase):
        rows = await TargetRepository.exist_target(db, target)
        value = rows["count"] == 1
        return api_response("Etiquetas listadas correctamente", True, value)
    
    @staticmethod
    async def exist_target_update(db: Connection, target_id:int, target:TargetBase):
        rows = await TargetRepository.exist_target_update(db, target_id, target)
        value = rows["count"] == 1
        return api_response("Etiquetas listadas correctamente", True, value)

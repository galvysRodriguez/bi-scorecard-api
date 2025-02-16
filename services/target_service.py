from asyncpg import Connection
from repositories.target_repo import TargetRepository
from schemas.target import TargetCreate
from utils.api_response import api_response
from services.indicator_service import fetch_indicator_value


class TargetService:
    @staticmethod
    async def get_target(db: Connection, target_id: int):
        """Obtiene un objetivo y lo convierte a respuesta de API."""
        row = await TargetRepository.get_target(db, target_id)
        if not row:
            return api_response("Target not found", False)

        indicator_value = await fetch_indicator_value(
            db, 
            row["indicator_id"], 
            row["aggregation_id"],
            row["start_date"],
            row["end_date"])

        target_data = {
                "id": row["id"],
                "title": row["title"],
                "optimal": row["optimal"],
                "tolerable": row["tolerable"],
                "deficient": row["deficient"],
                "indicator_id": row["indicator_id"],
                "aggregation_id": row["aggregation_id"],
                "start_date": row["start_date"],
                "end_date": row["end_date"],
                "indicator": row["indicator"],
                "aggregation": row["aggregation"],
                "perspective": row["perspective"],
                "indicator_value": indicator_value.get("data", {}).get("value")  # Extraer el valor si está disponible
            }
    

        return api_response("Target retrieved successfully", True, dict(target_data))

    @staticmethod
    async def get_targets(db: Connection, perspective_id: int):
        """Obtiene todos los objetivos y los devuelve como respuesta."""
        targets = await TargetRepository.get_targets(db, perspective_id)
        if not targets:
            return api_response("Targets not found", False)

        response_data = []
        
        for target in targets:
            indicator_value = await fetch_indicator_value(
                db, 
                target["indicator_id"], 
                target["aggregation_id"],
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
                "aggregation_id": target["aggregation_id"],
                "start_date": target["start_date"],
                "end_date": target["end_date"],
                "indicator": target["indicator"],
                "aggregation": target["aggregation"],
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
            indicator_value = await fetch_indicator_value(
                db, 
                target["indicator_id"], 
                target["aggregation_id"],
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
                "aggregation_id": target["aggregation_id"],
                "start_date": target["start_date"],
                "end_date": target["end_date"],
                "indicator": target["indicator"],
                "aggregation": target["aggregation"],
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
    async def update_target(db: Connection, target_id: int, update_data: dict):
        """Actualiza un objetivo existente."""
        row = await TargetRepository.update_target(db, target_id, **update_data)
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

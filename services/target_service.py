from asyncpg import Connection
from datetime import datetime
from repositories.target_repo import TargetRepository
from schemas.target import TargetCreate, TargetUpdate, TargetBase
from utils.api_response import api_response
from services.indicator_service import fetch_indicator_value
from services.formula_service import calc_formula_date, calc_formula_grouped
from datetime import datetime, timedelta, date
from collections import defaultdict
from decimal import Decimal

class TargetService:
    @staticmethod
    async def get_target(db: Connection, target_id: int):
        """Obtiene un objetivo y lo convierte a respuesta de API."""
        row = await TargetRepository.get_target(db, target_id)
        if not row:
            return api_response("Target not found", False)

        
        indicator_value = await calc_formula_date(
            db, 
            row["formula_id"], 
            row["start_date"],
            row["end_date"])
        
        progress, lack = calculate_progress(row, indicator_value.get("data", {}).get("value"))
        status = get_status(lack, row)

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
                "status": status,
                "lack": lack,
                "progress":progress,
                "indicator_value": indicator_value.get("data", {}).get("value")  # Extraer el valor si está disponible
            }
    

        return api_response("Target retrieved successfully", True, dict(target_data))
    
    async def get_target_perspectives(date_from:str, date_to:str, db: Connection):
        """Agrupa los estados de múltiples objetivos por perspectiva."""
        summary = defaultdict(lambda: {"active": 0, "failed": 0, "completed": 0})
    
        targets = await TargetRepository.get_all_targets(date_from, date_to, db)

        for row in targets:
            indicator_value = await calc_formula_date(
                db,
                row["indicator_id"],
                row["start_date"],
                row["end_date"]
            )

            progress, lack = calculate_progress(row, indicator_value.get("data", {}).get("value"))
            status = get_status(lack, row)

            perspective_id = row["perspective_id"]  
            perspective_name = row["perspective"]   

            summary[(perspective_id, perspective_name)][status] += 1

        result = [
            {"id": pid, "name": pname, **statuses}
            for (pid, pname), statuses in summary.items()
        ]

        return api_response("Resumen por perspectiva", True, result)

    
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


        indicator_value = await calc_formula_date(
            db, 
            row["formula_id"], 
            row["start_date"],
            row["end_date"])
        
        today = datetime.today()
        elapsed = max((today - row["start_date"]).days, 0)
        restant = max((row["end_date"] - today).days, 0)

        progress, lack = calculate_progress(row, indicator_value.get("data", {}).get("value"))

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
            "progress": progress,
            "indicator_value": indicator_value.get("data", {}).get("value")
        }

        return api_response("Target detail retrieved successfully", True, target_data)
    
    async def get_detail_chart_target(db: Connection, target_id: int, date_from: str, date_to: str):
        row = await TargetRepository.get_target(db, target_id)
        if not row:
            return api_response("Target not found", False)

        try:
            start = datetime.strptime(date_from, "%Y-%m-%d")
            end = datetime.strptime(date_to, "%Y-%m-%d")
        except ValueError:
            return api_response("Invalid date format. Use YYYY-MM-DD.", False)

        full_days = (end - start).days + 1
        if full_days > 30:
            start = end - timedelta(days=29)

        # Iterar por cada día
        daily_values = []
        current_day = start

        while current_day <= end:
            current_date = current_day.date()  # objeto date
            date_str = current_date.strftime("%Y-%m-%d")

            indicator_response = await calc_formula_date(
                db,
                row["formula_id"],
                start.date(),
                current_date
            )

            daily_values.append({
                "date": date_str,
                "value": round(indicator_response.get("data", {}).get("value"),2)
            })

            current_day += timedelta(days=1)

        target_data = {
            "target_id": row["id"],
            "results": daily_values
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
            
            progress, lack = calculate_progress(target, indicator_value.get("data", {}).get("value"))
            status = get_status(lack, target)
            
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
                "status": status,
                "lack": lack,
                "progress":progress,
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


def calculate_progress(target_data: TargetBase, total):
    total = Decimal(total) 

    optimal = Decimal(target_data["optimal"])
    tolerable = Decimal(target_data["tolerable"])

    if optimal > tolerable:
        progress = total * Decimal("100") / optimal
        lack = max(optimal - total, 0)
    elif total == 0:
        progress = Decimal("0")
        lack = max(optimal, 0)
    else:
        progress = optimal * Decimal("100") / total
        lack = max(total - optimal,0)

    return progress, lack
    
def get_status(lack: Decimal, target_data):
        today = datetime.today().date()
        
        try:
            if isinstance(target_data["end_date"], datetime):
                end_date = target_data["end_date"].date()
            else:
                end_date = datetime.strptime(target_data["end_date"], "%Y-%m-%d").date()
        except Exception:
            return "invalid"

        if end_date >= today:
            return "active"
        
        if lack == 0:
            return "completed"
        
        return "failed"


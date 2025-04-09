from fastapi import APIRouter, Depends
from datetime import datetime
from asyncpg import Connection
from services.formula_service import add_formula, get_formulas, calc_formula, calc_formula_date, calc_formula_grouped, delete_formula, update_formula, exist_formula
from db.database import get_db
from schemas.target import FormulaBase, FormulaCreate

router = APIRouter(prefix="/formula", tags=["formula"])

@router.post("/")
async def create_formula(formula_data: FormulaCreate, db: Connection = Depends(get_db)):
    response = await add_formula(db, formula_data)
    return response

@router.get("/")
async def get_all_formula(db: Connection = Depends(get_db)):
    response = await get_formulas(db)
    return response

@router.get("/general/{formula_id}")
async def get_formula(formula_id: int, db: Connection = Depends(get_db)):
    response = await calc_formula(db, formula_id)
    return response

@router.get("/{formula_id}")
async def get_formula_date(formula_id: int, start_date:datetime, end_date:datetime, db: Connection = Depends(get_db)):
    response = await calc_formula_date(db, formula_id, start_date, end_date)
    return response


@router.get("grouped/{formula_id}")
async def get_formula_date(formula_id: int, start_date:datetime, end_date:datetime, optimal:int, db: Connection = Depends(get_db)):
    response = await calc_formula_grouped(db, formula_id, start_date, end_date, optimal)
    return response


@router.put("/{formula_id}")
async def update_perspectives(formula_id: int, formula_data: FormulaCreate, db: Connection = Depends(get_db)):
    return await update_formula(db, formula_id, formula_data)

@router.delete("/{formula_id}")
async def delete_perspectives(formula_id: int, db: Connection = Depends(get_db)):
    return await delete_formula(db, formula_id)

@router.post("/exist")
async def get_formula_exist(formula_data: FormulaBase, db: Connection = Depends(get_db)):
    return await exist_formula(db, formula_data)




from fastapi import APIRouter, Depends, Query
from datetime import datetime
from asyncpg import Connection
from services.formula_service import add_formula, get_formulas, delete_formula, update_formula, exist_formula, get_formula, get_formula_tag, exist_formula_update, get_formulas_with_tag
from db.database import get_db
from schemas.target import FormulaBase, FormulaCreate
from typing import Optional

router = APIRouter(prefix="/formula", tags=["formula"])

@router.get("/exist")
async def get_formula_exist(title: str = Query(...), formula_id:Optional[int] = Query(None), db: Connection = Depends(get_db)):
    formula_data = FormulaBase(title=title)
    if formula_id is not None:
        return await exist_formula_update(db, formula_id, formula_data)
    return await exist_formula(db, formula_data)

@router.get("/")
async def get_all_formula(db: Connection = Depends(get_db)):
    response = await get_formulas(db)
    return response

@router.get("/tag")
async def get_all_formula(db: Connection = Depends(get_db)):
    response = await get_formulas_with_tag(db)
    return response


@router.get("/tag/{tag_id}")
async def get_tag_formula(tag_id: int, db: Connection = Depends(get_db)):
    response = await get_formula_tag(db, tag_id)
    return response

@router.get("/{formula_id}")
async def get_by_id_formula(formula_id: int, db: Connection = Depends(get_db)):
    response = await get_formula(db, formula_id)
    return response

@router.post("/")
async def create_formula(formula_data: FormulaCreate, db: Connection = Depends(get_db)):
    response = await add_formula(db, formula_data)
    return response

@router.put("/{formula_id}")
async def update_formula_router(formula_id: int, formula_data: FormulaCreate, db: Connection = Depends(get_db)):
    return await update_formula(db, formula_id, formula_data)

@router.delete("/{formula_id}")
async def delete_formula_router(formula_id: int, db: Connection = Depends(get_db)):
    return await delete_formula(db, formula_id)

